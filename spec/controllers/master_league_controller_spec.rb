require 'rails_helper'

RSpec.describe MasterLeagueController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      VCR.use_cassette("mlc#index") do
        user = User.create(name: "Greg Controller Armstrong",
                           summoner_name: "OctopusMachine",
                           region: "NA",
                           password: "password")
        get :index, user_id: user.id

        expect(response).to render_template("index")
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #comparison" do
    it "returns http success" do
      VCR.use_cassette("mlc#comparison") do
        user = User.create(name: "Greg Comparison Armstrong",
                           summoner_name: "OctopusMachine",
                           region: "NA",
                           password: "password")
        get :comparison, user_id: user.id, comparison: {summoner_name: "Xu Lanxuan Avi"}

        expect(response).to render_template("comparison")
        expect(response).to have_http_status(:success)
      end
    end
  end

end
