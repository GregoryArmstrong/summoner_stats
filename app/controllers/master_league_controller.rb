class MasterLeagueController < ApplicationController

  before_action :master_league_players_check

  def index
    @user = User.find(params[:user_id])
    @presenter = Presenter.new(@user) unless @user.summoner_name_and_region_absent?
    if @presenter
      @master_players = Rails.cache.read("10_master_player_games_averages")
    end
  end

  def comparison
    @user = User.find(params[:user_id])
    @presenter = Presenter.new(@user)
    @user_stats = @presenter.recent_games_averages(@user).averages
    @pro_stats = Rails.cache.read("master-league-player-games-averages").select { |player| player.summoner_name == params[:comparison][:summoner_name]}.first
    @kda_chart = create_kda_graph_chart(@user, @user_stats, @pro_stats)
    @ward_chart = create_ward_graph_chart(@user, @user_stats, @pro_stats)
    @creep_chart = create_creep_score_graph_chart(@user, @user_stats, @pro_stats)
    @user_pie_chart = champions_pie_chart(@user_stats)
    @pro_pie_chart = champions_pie_chart(@pro_stats.averages)
    @user_lane_pie_chart = lanes_pie_chart(@user_stats)
    @pro_lane_pie_chart = lanes_pie_chart(@pro_stats.averages)
  end

  private

  def lanes_arrays(lanes_info)
    total_games = lanes_info.values.reduce(:+)
    lanes_info.map do |lane, games|
      [lane, ((games.to_f / total_games.to_f)*100).round(2)]
    end
  end

  def lanes_pie_chart(stats)
    LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType => 'pie'})
      series = { :type => 'pie',
                 :name => "Percent Played",
                 :data => lanes_arrays(stats[:lanes])
                }
      f.series(series)
      f.legend(:layout => 'vertical',
               :style => {:left => 'auto',
                          :bottom => 'auto',
                          :right => '50px',
                          :top => '100px'})
      f.plot_options(:pie => {:allowPointSelect => true,
                              :cursor => 'pointer',
                              :dataLabels => {:enabled => true,
                                              :color => 'black',
                                              :style => {:fontSize => '25px'}
                                              }
                             }
                    )
    end
  end

  def champions_arrays(champions_info)
    total_games = champions_info.values.reduce(:+)
    champions_info.map do |champion|
      [champion[0][:name], ((champion[1].to_f / total_games.to_f)*100).round(2)]
    end
  end

  def champions_pie_chart(stats)
    LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType => "pie"})
      series = { :type => 'pie',
                 :name => "Percent Played",
                 :data => champions_arrays(stats[:champions_ids])
                }
      f.series(series)
      f.legend(:layout => 'vertical',
               :style => {:left => 'auto',
                          :bottom => 'auto',
                          :right => '50px',
                          :top => '100px'})
      f.plot_options(:pie => {:allowPointSelect => true,
                              :cursor => 'pointer',
                              :dataLabels => {:enabled => true,
                                              :color => 'black',
                                              :style => {:fontSize => "25px"}
                                             }
                             }
                    )
    end
  end

  def create_creep_score_graph_chart(user, user_stats, pro_stats)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:xAxis][:categories] = ['Creep Score']
      f.series(:type => 'column',
               :name => "#{user.summoner_name}",
               :data => [user_stats[:creep_scores]])
      f.series(:type => 'column',
               :name => "#{pro_stats.summoner_name}",
               :data => [pro_stats.averages[:creep_scores]])
    end
  end

  def create_ward_graph_chart(user, user_stats, pro_stats)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:xAxis][:categories] = ['Wards Placed',
                                        'Vision Wards Placed',
                                        'Wards Destroyed']
      f.series(:type => 'column',
               :name => "#{user.summoner_name}",
               :data => [user_stats[:wards_placed],
                         user_stats[:vision_wards],
                         user_stats[:wards_destroyed]])
      f.series(:type => 'column',
               :name => "#{pro_stats.summoner_name}",
               :data => [pro_stats.averages[:wards_placed],
                         pro_stats.averages[:vision_wards],
                         pro_stats.averages[:wards_destroyed]])
     end
  end

  def create_kda_graph_chart(user, user_stats, pro_stats)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:xAxis][:categories] = ['Kills',
                                        'Deaths',
                                        'Assists',
                                        'KDA']
      f.series(:type => 'column',
               :name => "#{user.summoner_name}",
               :data => [user_stats[:kills],
                         user_stats[:deaths],
                         user_stats[:assists],
                         user_stats[:kda]])
      f.series(:type => 'column',
               :name => "#{pro_stats.summoner_name}",
               :data => [pro_stats.averages[:kills],
                         pro_stats.averages[:deaths],
                         pro_stats.averages[:assists],
                         pro_stats.averages[:kda]])
    end
  end

  def master_league_players_check
    unless Rails.cache.read("10_master_player_games_averages")
      MasterLeagueWorker.perform_async(session[:user_id])
    end
  end

end
