
require 'rails_helper'

RSpec.feature 'USER show another user game', type: :feature do
  let(:user) { FactoryGirl.create :user }
  let!(:game_another_user) { FactoryGirl.create(:game) }

  before(:each) do
    login_as user
  end

  scenario 'successfully' do
    visit user_path(1)
    click_on('Billionaire')
    click_on('Новая игра')
    expect(page).to have_content('Жора')
    expect(page).to have_content('1')
    expect(page).to have_content('Хороший программист')
    expect(page).to have_content('Новая игра')
    expect(page).to have_content('Выигрыш')
    expect(page).to have_content('За игру')
    expect(page).to have_content('Место')
   end
end
