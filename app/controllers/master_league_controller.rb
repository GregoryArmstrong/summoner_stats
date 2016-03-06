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

  def show
    @user = User.find(params[:user_id])
    @presenter = Presenter.new(@user)
    @user_stats = @presenter.recent_games_averages(@user).averages
    @pro_stats = @presenter.master_league_player_games_averages.first.averages
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text => "Stats Comparison"})
      f.options[:xAxis][:categories] = ['Kills',
                                        'Deaths',
                                        'Assists',
                                        'KDA']
      f.series(:type => 'column', :name => "You", :data => [@user_stats[:kills],
                                                            @user_stats[:deaths],
                                                            @user_stats[:assists],
                                                            @user_stats[:kda]])
      f.series(:type => 'column', :name => "Pro", :data => [@pro_stats[:kills],
                                                            @pro_stats[:deaths],
                                                            @pro_stats[:assists],
                                                            @pro_stats[:kda]])
    end
  end

end
