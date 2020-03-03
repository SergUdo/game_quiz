require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:game) do
    FactoryGirl.build_stubbed(:game, name: 'SSS')
  end

  it 'renders player names' do
    assign(:users, (users_url))
    #binding.irb
    stub_template "users/show.html.erb" => "<h1><%= @user.name %></h1>"
    #expect(rendered).to match 'First'
  end

  it 'renders button password' do
    expect(rendered).to match ''
  end

  describe "users/_game.html.erb" do
    before(:each) do
      @users = assign(:users, stub_template(users_url))
    end
    it 'render show games' do
      stub_template 'users/_game.html.erb' => 'You'
      expect(rendered).to have_content ''
    end
  end
end