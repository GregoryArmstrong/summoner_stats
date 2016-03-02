class GameDataAverage

  attr_accessor :kills, :deaths, :assists
  attr_reader :games

  def initialize(games)
    @games = games
    @kills = []
    @deaths = []
    @assists = []
    load_data
  end

  def load_data
    @games.each do |game|
      @kills << game.kills.to_f
      @deaths << game.deaths.to_f
      @assists << game.assists.to_f
    end
  end

  def average(collection)
    (collection.reduce(:+) / collection.size)
  end



  def averages
    {
     kills: average(@kills),
     deaths: average(@deaths),
     assists: average(@assists),
     kda: ((average(@kills) + average(@assists)) / average(@deaths)).round(2)
    }
  end

end
