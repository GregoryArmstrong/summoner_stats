class GameDataAverage

  attr_accessor :kills, :deaths, :assists, :creep_scores, :wards_placed, :wards_destroyed, :vision_wards, :gold, :champions_ids, :lanes
  attr_reader :games

  def initialize(games)
    @games = games
    @kills = []
    @deaths = []
    @assists = []
    @gold = []
    @creep_scores = []
    @wards_placed = []
    @wards_destroyed = []
    @vision_wards = []
    @champions_ids = []
    @lanes = []
    load_data
  end

  def load_data
    @games.each do |game|
      @kills << game.kills.to_f
      @deaths << game.deaths.to_f
      @assists << game.assists.to_f
      @gold << game.gold_earned
      @creep_scores << game.creep_score.to_f
      @wards_placed << game.wards_placed.to_f
      @wards_destroyed << game.wards_destroyed.to_f
      @vision_wards << game.vision_wards.to_f
      @champions_ids << game.champion_id.to_i
      @lanes << game.lane
    end
  end

  def average(collection)
    (collection.reduce(:+) / collection.size)
  end

  def find_champions(collection)
    champions = {}
    collection.each do |item|
      champions[Champion.find_by(champion_id: item)] = 1 unless champions[Champion.find_by(champion_id: item)]
      champions[Champion.find_by(champion_id: item)] += 1 if champions[Champion.find_by(champion_id: item)]
    end
    champions
  end

  def find_lanes(collection)
    lanes = {top: 0, middle: 0, jungle: 0, bot: 0}
    collection.each do |item|
      lanes[:top] += 1 if item == 1
      lanes[:middle] += 1 if item == 2
      lanes[:jungle] += 1 if item == 3
      lanes[:bot] += 1 if item == 4
    end
    lanes
  end

  def averages
    {
     kills: average(@kills),
     deaths: average(@deaths),
     assists: average(@assists),
     kda: ((average(@kills) + average(@assists)) / average(@deaths)).round(2),
     gold: average(@gold).to_f,
     creep_scores: average(@creep_scores),
     wards_placed: average(@wards_placed),
     wards_destroyed: average(@wards_destroyed),
     vision_wards: average(@vision_wards),
     champions_ids: find_champions(@champions_ids),
     lanes: find_lanes(@lanes)
    }
  end

end
