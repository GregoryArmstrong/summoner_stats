require 'rails_helper'

RSpec.feature "GuestCanCreateAccount", type: :feature do
  scenario "guest can create a new account" do
    visit root_path

    click_link "Create Account"

    expect(current_path).to eq new_user_path

    fill_in "Name", with: "Gregory Armstrong"
    fill_in "Summoner Name", with: "OctopusMachine"
    fill_in "Region", with: "NA"
    click_on("Create Account")

    user = User.last

    expect(current_path).to eq user_path(user)
    expect(page).to have_content("Gregory Armstrong")
    expect(page).to have_content("OctopusMachine")
    expect(page).to have_content("NA")
  end
end
