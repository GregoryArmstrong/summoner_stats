class MasterLeaguePlayer

  attr_reader :summoner_name, :summoner_id, :region, :points
  attr_accessor :averages

  def initialize(player_info)
    @summoner_name = player_info[:playerOrTeamName]
    @summoner_id = player_info[:playerOrTeamId]
    @region = "NA"
    @points = player_info[:leaguePoints]
    @averages = []
  end

end
