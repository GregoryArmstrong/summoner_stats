RSpec.describe RiotService, :type => :model do
  context "summoner_id" do
    it "obtains a user's summoner id" do
      VCR.use_cassette("riot_service#obtain_summoner_id") do
        user = User.create(name: "Greg Riot Service Armstrong",
                           summoner_name: "OctopusMachine",
                           region: "NA",
                           password: "pass")

        expect(user.summoner_id).to eq nil

        expect(RiotService.new(user).summoner_id[:octopusmachine][:id]).to eq 45949943
        Rails.cache.clear
      end
    end
  end
  context "recent_games" do
    it "obtains all of a user's recent games" do
      VCR.use_cassette("riot_service#obtain_recent_games") do
        skip
        user = User.find_by(name: "Greg Riot Service Armstrong")

        expect(RiotService.new(user).recent_games(user)).to eq nil
        Rails.cache.clear
      end
    end
  end
  context "master_league_players_info" do
    it "obtains master league players info" do
      VCR.use_cassette("riot_service#master_league_players_info") do
        user = User.find_by(name: "Greg Riot Service Armstrong")

        expect(RiotService.new(user).master_league_players_info).to_not eq nil
        Rails.cache.clear
      end
    end
  end
end
