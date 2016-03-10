require 'open-uri'

class Presenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
    show_summoner_id if @current_user.summoner_id.nil?
    if (Champion.count != 129) || (Champion.where(image: nil).any?)
      all_champions
      single_champion_info
    end
    if Item.count != 248
      all_items
    end
  end

  def service
    RiotService.new(@current_user)
  end

  def show_summoner_id
    if @current_user.summoner_id.nil?
      service.summoner_id.each do |summoner|
        @current_user.summoner_id = summoner[1][:id]
      end
      @current_user.save
    end
    @current_user.summoner_id
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

  def all_champions
    Rails.cache.fetch("all_champions_info",
                      expires_in: 1.hours) do
      service.all_champions[:champions].each do |champion|
        Champion.find_or_create_by(champion_id: champion[:id]) do |new_champion|
          new_champion.ranked_play_enabled = champion[:rankedPlayEnabled]
          new_champion.free_to_play = champion[:freeToPlay]
        end
      end
    end
  end

  def single_champion_info
    Rails.cache.fetch("single_champions_info",
                      expires_in: 1.hours) do
      Champion.all.each do |champion|
        info = service.single_champion_info(champion)
        champion.name = info[:name]
        champion.title = info[:title]
        downloaded_image = open("http://ddragon.leagueoflegends.com/cdn/6.4.2/img/champion/#{info[:name].gsub("Vel'Koz", "Velkoz").gsub("Wukong", "MonkeyKing").gsub("LeBlanc", "Leblanc").gsub("Kha'Zix", "Khazix").gsub("Fiddlesticks", "FiddleSticks").gsub("Cho'Gath", "Chogath").gsub(" ", "").gsub("'", "").gsub(".", "")}.png")
        fetch_directory("app/assets/images/#{champion.name}")
        fetch_image(downloaded_image, "app/assets/images/#{champion.name}/#{champion.name}_image.png")
        champion.image = "#{champion.name}/#{champion.name}_image.png"
        champion.save
        info[:spells].each do |spell|
          downloaded_spell_image = open("http://ddragon.leagueoflegends.com/cdn/6.4.2/img/spell/#{spell[:image][:full]}")
          fetch_image(downloaded_spell_image, "app/assets/images/#{champion.name}/#{spell[:name].gsub(" / ", "_").gsub(" ", "_")}_image.png")
          spell = Spell.create(name: spell[:name],
                                 description: spell[:description],
                                 image: "#{champion.name}/#{spell[:name].gsub(" / ", "_").gsub(" ", "_")}_image.png")
          champion.spells << spell
        end
      end
    end
  end

  def all_items
    service.all_items[:data].each do |item|
      Item.find_or_create_by(item_id: item[1][:id]) do |new_item|
        new_item.name = item[1][:name]
        new_item.description = item[1][:plaintext]
        downloaded_image = open("http://ddragon.leagueoflegends.com/cdn/6.4.2/img/item/#{item[1][:id]}.png")
        fetch_directory("app/assets/images/items")
        fetch_image(downloaded_image, "app/assets/images/items/#{item[1][:name].gsub(" ", "").gsub("'", "")}_image.png")
        new_item.image = "items/#{item[1][:name].gsub(" ", "").gsub("'", "")}_image.png"
        new_item.save
      end
    end
  end

  # def first_master_league_player
  #   service.master_league_players_info[:entries].map do |player|
  #     [player[:playerOrTeamName], player[:leaguePoints]]
  #   end.sort_by! { |player| player[1] }.reverse[0]
  # end
  #
  # def master_league_players_info
  #   Rails.cache.fetch("master-league-players-info",
  #                     expires_in: 1.hours) do
  #     service.master_league_players_info[:entries].map do |player|
  #       new_master_player = MasterLeaguePlayer.new(player)
  #     end.sort_by! { |player| player.points }.reverse[0..9]
  #   end
  # end
  #
  # def master_league_player_games_averages
  #   Rails.cache.fetch("master-league-player-games-averages",
  #                     expires_in: 1.hours) do
  #     master_league_players_info.map do |player|
  #       sleep(1.0)
  #       player.averages = recent_games_averages(player).averages
  #       player
  #     end
  #   end
  # end

  private

  def fetch_directory(path)
    Dir.mkdir(path) unless File.exists?(path)
  end

  def fetch_image(downloaded_image, path)
    IO.copy_stream(downloaded_image, path) unless File.exists?(path)
  end

  def build_object(data)
    OpenStruct.new(data)
  end

end
