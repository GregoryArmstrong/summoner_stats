class Presenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
    if (Champion.count != 129) || (Champion.where(image: nil).any?)
      all_champions
      single_champion_info
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
    service.recent_games[:games].each do |game|
      build_object(game)
    end
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
      champion.image = "http://ddragon.leagueoflegends.com/cdn/img/champion/loading/#{info[:name]}_0.jpg"
      champion.save
    end
  end

  private

  def build_object(data)
    OpenStruct.new(data)
  end

end
