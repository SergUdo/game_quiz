
require 'rails_helper'

RSpec.feature 'USER show another user game', type: :feature do
  let(:user) { FactoryGirl.create :user, name: 'David'}
  let!(:game_another_user) { FactoryGirl.create(:game) }

  before(:each) do
    login_as user
  end

  scenario 'successfully' do
    visit '/'
    click_on('David')
    expect(page).to have_content('David')
    expect(page).to have_content('Выйти')
    expect(page).to have_content('Хороший программист')
    expect(page).to have_content('Новая игра')
    expect(page).to have_content('Выигрыш')
    expect(page).to have_content('Сменить имя и пароль')
    expect(page).to have_content('Подсказки')
    expect(page).to have_content('Вопрос')
    expect(page).to have_content('Дата')
  end
end
