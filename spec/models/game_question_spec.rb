# (c) goodprogrammer.ru

require 'rails_helper'
# Тестовый сценарий для модели игрового вопроса,
# в идеале весь наш функционал (все методы) должны быть протестированы.
RSpec.describe GameQuestion, type: :model do
  # задаем локальную переменную game_question, доступную во всех тестах этого сценария
  # она будет создана на фабрике заново для каждого блока it, где она вызывается
  let(:game_question) { FactoryGirl.create(:game_question, a: 2, b: 1, c: 4, d: 3) }
  # группа тестов на игровое состояние объекта вопроса
  context 'game status' do
    # тест на правильную генерацию хэша с вариантами
    it 'correct .variants' do
      expect(game_question.variants).to eq({'a' => game_question.question.answer2,
                                            'b' => game_question.question.answer1,
                                            'c' => game_question.question.answer4,
                                            'd' => game_question.question.answer3})
    end

    it 'correct .answer_correct?' do
      # именно под буквой b в тесте мы спрятали указатель на верный ответ
      expect(game_question.answer_correct?('b')).to be true
    end
  end
  # help_hash у нас имеет такой формат:
  # {
  #   fifty_fifty: ['a', 'b'], # При использовании подсказски остались варианты a и b
  #   audience_help: {'a' => 42, 'c' => 37 ...}, # Распределение голосов по вариантам a, b, c, d
  #   friend_call: 'Василий Петрович считает, что правильный ответ A'
  # }
  #
  context 'user helpers' do
    it 'correct audience_help' do
      expect(game_question.help_hash).not_to include(:audience_help)
      game_question.add_audience_help
      expect(game_question.help_hash).to include(:audience_help)
      ah = game_question.help_hash[:audience_help]
      expect(ah.keys).to contain_exactly('a', 'b', 'c', 'd')
    end
  end

    it 'correct .level & .text delegates' do
      expect(game_question.text).to eq(game_question.question.text)
      expect(game_question.level).to eq(game_question.question.level)
    end

  context 'model game_question' do
    it 'test method correct_answer_key' do
      expect(game_question.correct_answer_key).to eq('b')
    end
  end

  context 'help_hash' do
    it 'test model help' do
      expect(game_question.help_hash).to include({})
    end
  end

  context 'fifty_fifty' do
    it 'test method fifty_fifty' do
      expect(game_question.add_fifty_fifty).to be_truthy
      game_question.add_fifty_fifty

      expect(game_question.help_hash).to include(:fifty_fifty)
      ff = game_question.help_hash[:fifty_fifty]

      expect(ff).to include('b')
      expect(ff.size).to eq 2
    end
  end

  context 'add_friend_call' do
    it 'test add_friend_call' do
      game_question.add_friend_call
      expect(game_question.help_hash[:friend_call]).to be
      expect(game_question.add_friend_call).to be_truthy
      game_question.help_hash[:friend_call] = "Борис Бурда считает, что это вариант C"
      expect(game_question.help_hash[:friend_call]).to eq("Борис Бурда считает, что это вариант C")
    end
  end
end
