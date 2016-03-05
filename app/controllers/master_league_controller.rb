class MasterLeagueController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    unless @user.summoner_name.nil? || @user.region.nil?
      @presenter = Presenter.new(@user)
    end
    if @presenter
      @master_players = @presenter.master_league_player_games_averages
      binding.pry
    end
  end

end
