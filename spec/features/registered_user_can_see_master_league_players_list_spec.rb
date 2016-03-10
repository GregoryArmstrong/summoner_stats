require 'rails_helper'

RSpec.feature "RegisteredUserCanSeeMasterLeaguePlayersList", type: :feature do
  scenario "logged in and registered user can see master league players list" do
    VCR.use_cassette("master_league_controller#index") do
      user = User.create(name: "Greg Master League Armstrong",
                         summoner_name: "OctopusMachine",
                         region: "NA",
                         password: "password")
      visit root_path

      click_link "Login"

      expect(current_path).to eq new_session_path

      fill_in "Name", with: user.name
      fill_in "Password", with: user.password
      click_on("Login")

      expect(current_path).to eq user_path(user)
      expect(page).to have_content("Greg Master League Armstrong")
      expect(page).to have_content("OctopusMachine")
      expect(page).to have_content("NA")
      expect(page).to have_content("45949943")
      expect(page).to_not have_content("Master League Players")

      sleep(25)

      visit user_path(user)

      expect(page).to have_content("Master League Players")
      click_on("Master League Players")

      expect(current_path).to eq user_master_league_index_path(user)

      Rails.cache.clear
    end
  end
end
