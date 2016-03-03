require 'open-uri'

class Presenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
    if @current_user.summoner_id.nil?
      show_summoner_id
    end
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
    if @current_user.summoner_id == nil
      service.summoner_id.each do |summoner|
        @current_user.summoner_id = summoner[1][:id]
      end
      @current_user.save
      @current_user.summoner_id
    else
      @current_user.summoner_id
    end
  end

  def recent_games
    service.recent_games[:games].map do |game|
      GameData.new(game)
    end
  end

  def recent_games_averages
    GameDataAverage.new(recent_games)
  end

  def all_champions
    service.all_champions[:champions].each do |champion|
      Champion.find_or_create_by(champion_id: champion[:id]) do |new_champion|
        new_champion.ranked_play_enabled = champion[:rankedPlayEnabled]
        new_champion.free_to_play = champion[:freeToPlay]
      end
    end
  end

  def single_champion_info
    Champion.all.each do |champion|
      info = service.single_champion_info(champion)
      champion.name = info[:name]
      champion.title = info[:title]
      downloaded_image = open("http://ddragon.leagueoflegends.com/cdn/6.4.2/img/champion/#{info[:name].gsub("Vel'Koz", "Velkoz").gsub("Wukong", "MonkeyKing").gsub("LeBlanc", "Leblanc").gsub("Kha'Zix", "Khazix").gsub("Fiddlesticks", "FiddleSticks").gsub("Cho'Gath", "Chogath").gsub(" ", "").gsub("'", "").gsub(".", "")}.png")
      Dir.mkdir("app/assets/images/#{champion.name}") unless File.exists?("app/assets/images/#{champion.name}")
      IO.copy_stream(downloaded_image, "app/assets/images/#{champion.name}/#{champion.name}_image.png")
      champion.image = "assets/#{champion.name}/#{champion.name}_image.png"
      champion.save
      info[:spells].each do |spell|
        downloaded_spell_image = open("http://ddragon.leagueoflegends.com/cdn/6.4.2/img/spell/#{spell[:image][:full]}")
        IO.copy_stream(downloaded_spell_image, "app/assets/images/#{champion.name}/#{spell[:name].gsub(" / ", "_").gsub(" ", "_")}_image.png")
        spell = Spell.create(name: spell[:name],
                               description: spell[:description],
                               image: "assets/#{champion.name}/#{spell[:name]}_image.png")
        champion.spells << spell
      end
    end
  end

  def all_items
    service.all_items[:data].each do |item|
      Item.find_or_create_by(item_id: item[1][:id]) do |new_item|
        new_item.name = item[1][:name]
        new_item.description = item[1][:plaintext]
        downloaded_image = open("http://ddragon.leagueoflegends.com/cdn/6.4.2/img/item/#{item[1][:id]}.png")
        Dir.mkdir("app/assets/images/items") unless File.exists?("app/assets/images/items")
        IO.copy_stream(downloaded_image, "app/assets/images/items/#{item[1][:name].gsub(" ", "").gsub("'", "")}_image.png")
        new_item.image = "assets/items/#{item[1][:name].gsub(" ", "").gsub("'", "")}_image.png"
        new_item.save
      end
    end
  end

  private

  def build_object(data)
    OpenStruct.new(data)
  end

end
