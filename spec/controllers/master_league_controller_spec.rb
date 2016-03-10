require 'rails_helper'

RSpec.describe MasterLeagueController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      binding.pry
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
