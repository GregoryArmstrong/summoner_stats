RSpec.describe MasterLeagueWorker, :type => :model do
  context "perform" do
    it "performs perform performantly" do
      VCR.use_cassette("master_league_worker#perform") do
        skip
        user = User.create(name: "Greg Riot Service Armstrong",
                           summoner_name: "OctopusMachine",
                           region: "NA",
                           password: "pass")

        Rails.cache.clear("10_master_player_games_averages")

        expect(Rails.cache.read("10_master_player_games_averages")).to eq nil

        MasterLeagueWorker.perform_async(user.id)
        sleep(15)

        expect(Rails.cache.read("10_master_player_games_averages")).to_not eq nil
        Rails.cache.clear
      end
    end
  end
end
