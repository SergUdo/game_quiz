
require 'rails_helper'

RSpec.feature 'USER show another user game', type: :feature do

  let(:user) { FactoryGirl.create :user }

  let!(:game_another_user) { FactoryGirl.create(:game) }

  before(:each) do
    login_as user
  end

scenario 'successfully' do
   visit user_path(1)
   click_on('Новая игра')
   expect(page).to have_current_path user_path(1)
   expect(page).to have_content('Жора')
   expect(page).to have_content('1')
   expect(page).to have_content('Дата')
   expect(page).to have_content('Новая игра')
   expect(page).to have_content('Выигрыш')
   expect(page).to have_content('Подсказки')
   expect(page).to have_content('Вопрос')
 end
end
