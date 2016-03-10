RSpec.describe MasterLeaguePlayerBuilder, :type => :model do
  context "create" do
    it "correctly creates objects" do
      VCR.use_cassette("master_league_player_builder#initialize") do
        user = User.create(name: "Greg MLPB Armstrong",
                           summoner_name: "OctopusMachine",
                           region: "NA",
                           password: "derpderp")
        mlpb = MasterLeaguePlayerBuilder.new(user.id)

        expect(mlpb.master_league_players.count).to eq 10
      end
    end
  end
end
