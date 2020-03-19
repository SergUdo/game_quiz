require 'rails_helper'

RSpec.feature 'user show another user game', type: :feature do
  let(:user) { FactoryGirl.create :user, name: 'David'}
  let(:another_user) { FactoryGirl.create :user, name: 'Vadik'}

  let!(:games) do [
      FactoryGirl.create(:game, id: 1, user: another_user, prize: 0, current_level: 1, is_failed: true, created_at: '2020-02-23 15:44:22', finished_at: '2020-02-23 16:33:22'),
      FactoryGirl.create(:game, id: 2, user: another_user, prize: 10000, current_level: 5, created_at: '2020-02-23 15:44:22')
    ]
  end

  before(:each) do
    login_as user
  end

  scenario 'successfully' do
    visit '/'
    click_on('Vadik')
    expect(page).to have_current_path "/users/#{another_user.id}"
    expect(page).to have_content('David')
    expect(page).to have_content('Выйти')
    expect(page).to have_content('Хороший программист')
    expect(page).to have_content('Новая игра')
    expect(page).to have_content('Выигрыш')
    expect(page).to have_content('David - 0 ₽')
    expect(page).to have_content('Подсказки')
    expect(page).to have_content('Вопрос')
    expect(page).to have_content('Дата')
    expect(page).to have_content('в процессе')
    expect(page).to have_content('23 февр')
    expect(page).to have_content('10 000')
    expect(page).to have_content('50/50')
  end
end
