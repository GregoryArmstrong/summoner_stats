require 'rails_helper'

RSpec.feature "UserCanLogin", type: :feature do
  scenario "registered user can log in" do
    VCR.use_cassette("users#login") do
      user = User.create(name: "Greg Login Armstrong",
                         password: "password",
                         summoner_name: "OctopusMachine",
                         region: "NA")
      visit root_path

      click_link "Login"

      expect(current_path).to eq new_session_path

      fill_in "Name", with: user.name
      fill_in "Password", with: user.password
      click_on("Login")

      expect(current_path).to eq user_path(user)
      expect(page).to have_content("Greg Login Armstrong")
      expect(page).to have_content("OctopusMachine")
      expect(page).to have_content("NA")
    end
  end
end
