require 'rails_helper'

RSpec.feature "UserCanLogout", type: :feature do
  scenario "registered user can log out" do
    visit root_path

    click_link "Create Account"

    expect(current_path).to eq new_user_path

    fill_in "Name", with: "Gregory Armstrong"
    fill_in "Summoner Name", with: "OctopusMachine"
    fill_in "Region", with: "NA"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    click_on("Create Account")

    user = User.last

    expect(current_path).to eq user_path(user)

    click_on("Logout")

    expect(current_path).to eq root_path
  end
end
