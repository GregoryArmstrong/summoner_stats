require 'rails_helper'

RSpec.feature "UserCanLogin", type: :feature do
  scenario "registered user can log in" do
    user = User.find_by(name: "Greg Armstrong")
    visit root_path

    click_link "Login"

    expect(current_path).to eq new_session_path

    fill_in "Name", with: "Greg Armstrong"
    fill_in "Password", with: "password"
    click_on("Login")

    user.reload

    expect(current_path).to eq user_path(user)
    expect(page).to have_content("Greg Armstrong")
    expect(page).to have_content("OctopusMachine")
    expect(page).to have_content("NA")
  end
end
