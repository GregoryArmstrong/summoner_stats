require 'rails_helper'

RSpec.feature "GuestCanCreateAccount", type: :feature do
  scenario "guest can create a new account" do
    VCR.use_cassette("user#guest") do
      visit root_path

      click_link "Create Account"

      expect(current_path).to eq new_user_path

      fill_in "Name", with: "Gregory Armstrong"
      fill_in "Summoner Name", with: "OctopusMachine"
      fill_in "Regions: NA, BR, EUNE, EUW, KR, LAN, LAS, OCE, RU, TR", with: "NA"
      fill_in "Password", with: "password"
      fill_in "Password Confirmation", with: "password"
      click_on("Create Account")

      user = User.last

      expect(current_path).to eq user_path(user)
      expect(page).to have_content("Gregory Armstrong")
      expect(page).to have_content("OctopusMachine")
      expect(page).to have_content("NA")
    end
  end

  scenario "guest can update account" do
    VCR.use_cassette("user#update") do
      user = User.create(name: "Greg",
                         password: "password")
      visit root_path

      click_on("Login")

      expect(current_path).to eq new_session_path

      fill_in "Name", with: user.name
      fill_in "Password", with: user.password
      click_on("Login")

      expect(current_path).to eq user_path(user)
      expect(page).to have_content(user.name)
      expect(page).to_not have_content("NA")
      expect(page).to_not have_content("OctopusMachine")

      click_on("Add Summoner Name/Region")

      expect(current_path).to eq edit_user_path(user)

      fill_in "Summoner Name", with: "OctopusMachine"
      fill_in "Region", with: "NA"
      click_on("Update")

      expect(current_path).to eq user_path(user)

      expect(page).to have_content(user.name)
      expect(page).to have_content("NA")
      expect(page).to have_content("OctopusMachine")
    end
  end
end
