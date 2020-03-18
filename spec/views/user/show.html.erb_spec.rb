require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    assign(:games, FactoryGirl.build_stubbed(:game))
    render
  end

  it 'renders show' do
    expect(rendered).to match 'aaa@mail.com'
    expect(rendered).to have_content('sss')
  end
end
