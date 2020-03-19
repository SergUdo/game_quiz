require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  context 'watch page' do
    before(:each) do
      assign(:user, FactoryGirl.build_stubbed(:user, name: 'Vadik'))
      assign(:games, [FactoryGirl.build_stubbed(:game, id: 1, created_at: '2020-02-23 15:44:22', current_level: 1)])

      render
    end

    it 'renders player name' do
      expect(rendered).to match 'Vadik'
    end

    it 'watch change name and password' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end
  end

  context 'user watches page' do
    before(:each) do
      user = FactoryGirl.create(:user, name: 'Gogi')
      sign_in user
      assign(:user, user)

      assign(:games, [FactoryGirl.build_stubbed(:game, id: 2, created_at: '2020-02-23 15:44:22', current_level: 2)])

      render
    end

    it 'renders player name' do
      expect(rendered).to have_content 'Gogi'
    end

    it 'renders correct user change password' do
      expect(rendered).to have_content 'Сменить имя и пароль'
    end
  end
end
