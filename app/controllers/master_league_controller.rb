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

  def comparison
    @user = User.find(params[:user_id])
    @presenter = Presenter.new(@user)
    @user_stats = @presenter.recent_games_averages(@user).averages
    @pro_stats = @presenter.master_league_player_games_averages.select { |player| player.summoner_name == params[:comparison][:summoner_name]}.first
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
      f.series(:type => 'column', :name => "#{@pro_stats.summoner_name}", :data => [@pro_stats.averages[:kills],
                                                                                    @pro_stats.averages[:deaths],
                                                                                    @pro_stats.averages[:assists],
                                                                                    @pro_stats.averages[:kda]])
    end
  end

end
