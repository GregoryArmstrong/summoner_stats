require 'rails_helper'

RSpec.feature "UserLogsInWithTwitters", type: :feature do
  before do
    stub_omniauth
  end
  scenario "guest can create a new account via twitter login" do
    visit root_path

    click_link "Login with Twitter"

    expect(current_path).to eq root_path
    expect(page).to have_content("Gregory Armstrong")
  end
end
