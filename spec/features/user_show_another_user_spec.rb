
require 'rails_helper'

 RSpec.feature 'USER show another user game', type: :feature do

   let(:user) { FactoryGirl.create :user }

   let!(:game_another_user) { FactoryGirl.create(:game) }

  scenario 'successfully' do
     visit user_path(1)
     expect(page).to have_current_path user_path(1)
     expect(page).to have_content('Жора')
     expect(page).to have_content('1')
     expect(page).to have_content('Выигрыш')
     expect(page).to have_content('Войти')
   end
 end
