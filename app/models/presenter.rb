class Presenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
    show_summoner_id
    if (Champion.count != 129) || (Champion.where(image: nil).any?)
      all_champions
      single_champion_info
    end
    all_items
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
      champion.image = "http://ddragon.leagueoflegends.com/cdn/6.4.2/img/champion/#{info[:name].gsub(" ", "").gsub("'", "").gsub(".", "")}.png"
      champion.save
      info[:spells].each do |spell|
        spell = Spell.create(name: spell[:name],
                               description: spell[:description],
                               image: "http://ddragon.leagueoflegends.com/cdn/6.4.2/img/spell/#{spell[:image][:full]}")
        champion.spells << spell
      end
    end
  end

  def all_items
    service.all_items[:data].each do |item|
      Item.find_or_create_by(item_id: item[1][:id]) do |new_item|
        new_item.name = item[1][:name]
        new_item.description = item[1][:plaintext]
        new_item.image = "http://ddragon.leagueoflegends.com/cdn/6.4.2/img/item/#{item[1][:id]}.png"
        new_item.save
      end
    end
  end

  private

  def build_object(data)
    OpenStruct.new(data)
  end

end
