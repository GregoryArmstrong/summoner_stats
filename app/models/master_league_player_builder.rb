class MasterLeaguePlayerBuilder

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def service
    RiotService.new(user)
  end

  def master_league_players_info
    service.master_league_players_info.map do |player|
      build_object(player)
    end
  end

  private

  def build_object(data)
    OpenStruct.new(data)
  end

end
