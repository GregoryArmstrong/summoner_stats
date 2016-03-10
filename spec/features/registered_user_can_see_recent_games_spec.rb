require 'rails_helper'

RSpec.feature "RegisteredUserCanSeeRecentGames", type: :feature do
  scenario "logged in and registered user can see recent games on dashboard" do
    VCR.use_cassette("riot_service#recent_games") do
      user = User.create(name: "Greg Recent Games Armstrong",
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
      expect(page).to have_content("10 Most Recent Games' Averages")
      expect(page).to have_content("Greg Recent Games Armstrong")
      expect(page).to have_content("OctopusMachine")
      expect(page).to have_content("NA")
      expect(page).to have_content("45949943")
    end
  end
end
