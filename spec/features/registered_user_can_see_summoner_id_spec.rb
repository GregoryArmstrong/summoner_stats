require 'rails_helper'

RSpec.feature "RegisteredUserCanSeeSummonerId", type: :feature do
  scenario "logged in and registered user can see summoner_id on dashboard" do
    VCR.use_cassette("riot_service#summoner_id") do
      user = User.create(name: "Gregory T Armstrong",
                         summoner_name: "OctopusMachine",
                         region: "NA",
                         password: "password"
                         )
      visit root_path

      click_link "Login"

      expect(current_path).to eq new_session_path

      fill_in "Name", with: user.name
      fill_in "Password", with: user.password
      click_on("Login")

      expect(current_path).to eq user_path(user)
      expect(page).to have_content("Gregory T Armstrong")
      expect(page).to have_content("OctopusMachine")
      expect(page).to have_content("NA")
      expect(page).to have_content("45949943")
      Rails.cache.clear
    end
  end
end
