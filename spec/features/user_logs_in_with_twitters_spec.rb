require 'rails_helper'

RSpec.feature "UserLogsInWithTwitters", type: :feature do
  before do
    stub_omniauth
  end
  scenario "guest can create a new account via twitter login" do
    VCR.use_cassette("twitter#login") do
      visit root_path

      click_link "Login with Twitter"

      user = User.last

      expect(current_path).to eq user_path(user)
      expect(page).to have_content("Gregory Armstrong")
    end
  end

  scenario "guest who has registered via twitter oauth can add summoner name/region" do
    VCR.use_cassette("twitter#edit") do
      visit root_path

      click_link "Login with Twitter"

      user = User.last

      expect(current_path).to eq user_path(user)

      expect(page).to have_content("Gregory Armstrong")
      expect(page).to_not have_content("OctopusMachine")
      expect(page).to_not have_content("NA")

      click_link "Add Summoner Name/Region"

      fill_in "Summoner Name", with: "OctopusMachine"
      fill_in "Region", with: "NA"
      click_on("Update")

      expect(current_path).to eq user_path(user)
      expect(page).to have_content("OctopusMachine")
      expect(page).to have_content("NA")
    end
  end
end
