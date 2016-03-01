require 'rails_helper'

RSpec.feature "UserLogsInWithTwitters", type: :feature do
  before do
    stub_omniauth
  end
  scenario "guest can create a new account via twitter login" do
    visit root_path

    click_link "Login with Twitter"

    user = User.last

    expect(current_path).to eq user_path(user)
    expect(page).to have_content("Gregory Armstrong")
  end
end
