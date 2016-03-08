class MasterLeaguePlayerBuilder

  attr_reader :user, :master_league_players

  def initialize(user_id)
    @user = User.find(user_id)
    @master_league_players = Rails.cache.fetch("10_master_player_games_averages",
                      expires_in: 1.hours) do
      master_league_player_games_averages
    end
  end

  def service
    RiotService.new(@user)
  end

  def recent_games(player)
    Rails.cache.fetch("#{player.summoner_name}-recent-games",
                      expires_in: 1.hours) do
      service.recent_games(player)[:games].map do |game|
        GameData.new(game)
      end
    end
  end

  def recent_games_averages(player)
    Rails.cache.fetch("#{player.summoner_name}-recent-games-averages",
                      expires_in: 1.hours) do
      GameDataAverage.new(recent_games(player))
    end
  end

  def master_league_players_info
    Rails.cache.fetch("master-league-players-info",
                      expires_in: 1.hours) do
      service.master_league_players_info[:entries].map do |player|
        new_master_player = MasterLeaguePlayer.new(player)
      end.sort_by! { |player| player.points }.reverse[0..9].sort
    end
  end

  def master_league_player_games_averages
    Rails.cache.fetch("master-league-player-games-averages",
                      expires_in: 1.hours) do
      master_league_players_info.map do |player|
        sleep(1.0)
        player.averages = recent_games_averages(player).averages
        player
      end
    end
  end

  private

  def build_object(data)
    OpenStruct.new(data)
  end

end
