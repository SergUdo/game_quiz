# (c) goodprogrammer.ru

require 'rails_helper'
require 'support/my_spec_helper' # наш собственный класс с вспомогательными методами

# Тестовый сценарий для модели Игры
# В идеале - все методы должны быть покрыты тестами,
# в этом классе содержится ключевая логика игры и значит работы сайта.
RSpec.describe Game, type: :model do
  # пользователь для создания игр
  let(:user) { FactoryGirl.create(:user) }

  # игра с прописанными игровыми вопросами
  let(:game_w_questions) { FactoryGirl.create(:game_with_questions, user: user) }

  # Группа тестов на работу фабрики создания новых игр
  context 'Game Factory' do
    it 'Game.create_game! new correct game' do
      # генерим 60 вопросов с 4х запасом по полю level,
      # чтобы проверить работу RANDOM при создании игры
      generate_questions(60)
      game = nil
      # создaли игру, обернули в блок, на который накладываем проверки
      expect {
        game = Game.create_game_for_user!(user)
      }.to change(Game, :count).by(1).and(# проверка: Game.count изменился на 1 (создали в базе 1 игру)
        change(GameQuestion, :count).by(15).and(# GameQuestion.count +15
          change(Question, :count).by(0) # Game.count не должен измениться
        )
      )
      # проверяем статус и поля
      expect(game.user).to eq(user)
      expect(game.status).to eq :in_progress
      # проверяем корректность массива игровых вопросов
      expect(game.game_questions.size).to eq(15)
      expect(game.game_questions.map(&:level)).to eq (0..14).to_a
    end
  end

  # тесты на основную игровую логику
  context 'game mechanics' do
    # правильный ответ должен продолжать игру
    it 'answer correct continues game' do
      # текущий уровень игры и статус
      level = game_w_questions.current_level
      q = game_w_questions.current_game_question
      expect(game_w_questions.status).to eq :in_progress
      game_w_questions.answer_current_question!(q.correct_answer_key)
      # перешли на след. уровень
      expect(game_w_questions.current_level).to eq(level + 1)
      # ранее текущий вопрос стал предыдущим
      expect(game_w_questions.previous_game_question).to eq(q)
      expect(game_w_questions.current_game_question).not_to eq(q)
      # игра продолжается
      expect(game_w_questions.status).to eq :in_progress
      expect(game_w_questions.finished?).to be_falsey
    end
  end

  context 'take money' do
    it 'conditions take_money user' do
      b = game_w_questions.current_game_question
      game_w_questions.answer_current_question!(b.correct_answer_key)
      game_w_questions.take_money!
      prize = game_w_questions.prize
      expect(prize).to be > 0
      expect(game_w_questions.status).to eq :money
      expect(game_w_questions.finished?).to eq true
      expect(user.balance).to eq prize
    end
  end

  context '.status' do
  # перед каждым тестом "завершаем игру"
    before(:each) do
      game_w_questions.finished_at = Time.now
      expect(game_w_questions.finished?).to be_truthy
    end

    it ':won' do
      game_w_questions.current_level = Question::QUESTION_LEVELS.max + 1
      expect(game_w_questions.status).to eq :won
    end

    it ':fail' do
      game_w_questions.is_failed = true
      expect(game_w_questions.status).to eq :fail
    end

    it ':timeout' do
      game_w_questions.created_at = 1.hour.ago
      game_w_questions.is_failed = true
      expect(game_w_questions.status).to eq :timeout
    end

    it ':money' do
      expect(game_w_questions.status).to eq :money
    end
  end

  context '.current_game_question' do
    it 'current level' do
      expect(game_w_questions.current_game_question).to eq(game_w_questions.game_questions[0])
    end
  end

  context '.previous_level' do
    it 'previous_level' do
      expect(game_w_questions.previous_level).to eq(-1)
    end
  end

  describe '#answer_current_question!' do
    let(:answer) { game_w_questions.current_game_question.correct_answer_key }
    before { game_w_questions.answer_current_question!(answer) }

    context 'when answer is correct' do
      context 'when question is last' do
        let(:game_w_questions) { FactoryGirl.create(:game_with_questions, user: user, current_level: 14) }

        it "game is finished" do
          expect(game_w_questions).to be_finished
        end

        it "game status is won" do
          expect(game_w_questions.status).to eq :won
        end

        it "game has maximal prize" do
          expect(game_w_questions.prize).to eq 1_000_000
        end
      end

      context 'when question is not last' do
        it "game is not finished" do
          expect(game_w_questions).not_to be_finished
        end

        it "game status is in progress" do
          expect(game_w_questions.status).to eq :in_progress
        end
      end
    end

    context 'when answer is correct' do
      let(:correct_answer)  { game_w_questions.current_game_question.correct_answer_key }
      it 'when status is correct' do
        expect(game_w_questions.status).to eq :in_progress
        expect(game_w_questions.answer_current_question!(correct_answer)).to be
        expect(game_w_questions).to_not be_finished
      end
    end

    context 'when answer is incorrect' do
      let(:wrong_answer) { %w[a b c d].delete_if { |i| i == game_w_questions.current_game_question.correct_answer_key}.sample }
      before { game_w_questions.answer_current_question!(wrong_answer) }

      it "game status is fail" do
        expect(game_w_questions.status).to eq :fail
        expect(game_w_questions.answer_current_question!(wrong_answer)).to be(false)
        expect(game_w_questions).to be_finished
      end
    end

    context 'when time is over' do
      let(:game_w_questions) { FactoryGirl.create(:game_with_questions, user: user, created_at: 1.hour.ago) }

      it "game status is timeout" do
        expect(game_w_questions.status).to eq :timeout
      end

      it "game is finished" do
        expect(game_w_questions).to be_finished
      end
    end
  end
end
