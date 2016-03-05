class MasterLeagueController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    unless @user.summoner_name.nil? || @user.region.nil?
      @presenter = Presenter.new(@user)
    end
    if @presenter
      @master_players = Rails.cache.fetch("#{@presenter.first_master_league_player}",
                        expires_in: 1.hours) do
        @presenter.master_league_player_games_averages
      end
    end
  end

end
