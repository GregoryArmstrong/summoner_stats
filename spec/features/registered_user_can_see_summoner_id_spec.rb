require 'rails_helper'

RSpec.feature "RegisteredUserCanSeeSummonerId", type: :feature do
  scenario "logged in and registered user can see summoner_id on dashboard" do
      user = User.create(name: "Greg Armstrong",
                         summoner_name: "OctopusMachine",
                         region: "NA",
                         password: "password"
                         )
      visit root_path

      click_link "Login"

      expect(current_path).to eq new_session_path

      fill_in "Name", with: "Greg Armstrong"
      fill_in "Password", with: "password"
      click_on("Login")

      user = User.last

      expect(current_path).to eq user_path(user)
      expect(page).to have_content("Greg Armstrong")
      expect(page).to have_content("OctopusMachine")
      expect(page).to have_content("NA")
      expect(page).to have_content("45949943")
  end
end
