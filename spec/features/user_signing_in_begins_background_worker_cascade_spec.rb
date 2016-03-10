require 'rails_helper'

RSpec.feature "UserSignInStartsBackgroundWorker", type: :feature do
  scenario "registered user starts background worker cascade" do
    skip
    visit root_path

    click_link "Login"

    expect(current_path).to eq new_session_path

    fill_in "Name", with: "Greg Armstrong"
    fill_in "Password", with: "password"
    click_on("Login")

    expect(page).to_not have_content("Master League Players")

    sleep(10)

    visit user_path(user)
    expect(page).to have_content("Master League Players")
    Rails.cache.clear
  end
end
