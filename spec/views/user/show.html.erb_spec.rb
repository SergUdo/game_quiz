require 'rails_helper'

 RSpec.describe 'users/show', type: :view do

  describe 'user show his view' do
    let(:user) { FactoryGirl.build_stubbed(:user, game: '1', name: 'qqq') }
    before(:each) do

     render
    end

    #  stub_template 'users/show.html.erb' => 'Сменить имя и пароль'
    #  expect(rendered).to have_content 'Сменить имя и пароль'


     it 'renders player names' do
       expect(rendered).to have_content('Вадик')
     end
#   #end

#   # context 'user show his view' do
#   #   it 'renders player names' do
#   #     assign(:users, (users_url))
#   #     stub_template "users/show.html.erb" => "SSS"
#   #     expect(rendered).to match 'SSS'
  end
end
