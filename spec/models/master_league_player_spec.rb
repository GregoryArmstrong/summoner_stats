RSpec.describe MasterLeaguePlayer, :type => :model do
  context "create" do
    it "correctly attributes its input" do
      VCR.use_cassette("master_league_player#initialize") do
        mlp = MasterLeaguePlayer.new({:playerOrTeamId=>"37475736",
                                      :playerOrTeamName=>"WickedWazer",
                                      :division=>"I",
                                      :leaguePoints=>303,
                                      :wins=>70,
                                      :losses=>35,
                                      :isHotStreak=>false,
                                      :isVeteran=>false,
                                      :isFreshBlood=>false,
                                      :isInactive=>false})

        expect(mlp.summoner_name).to eq "WickedWazer"
        expect(mlp.summoner_id).to eq "37475736"
        expect(mlp.region).to eq "NA"
        expect(mlp.points).to eq 303
        Rails.cache.clear
      end
    end
  end
end
