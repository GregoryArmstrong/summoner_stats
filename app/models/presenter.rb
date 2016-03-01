class Presenter

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
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

  private

  def build_object(data)
    OpenStruct.new(data)
  end

end
