class GameData

  attr_reader :game

  def initialize(game)
    @game = game  
  end

  def game_id
    @game[:gameId]
  end

  def champion_id
    @game[:championId]
  end

  def champion_image
    champion.image
  end

  def champion_name
    champion.name
  end

  def champion
    Champion.find_by(champion_id: @game[:championId])
  end

  def win?
    @game[:stats][:win]
  end

  def kills
    @game[:stats][:championsKilled] || 0
  end

  def deaths
    @game[:stats][:numDeaths] || 0
  end

  def assists
    @game[:stats][:assists] || 0
  end

  def kda
    (((kills.to_f + assists.to_f) / deaths.to_f).round(2))
  end

  def game_type
    @game[:subType].gsub("_", " ")
  end

  def ip_earned
    @game[:ipEarned]
  end

  def max_level
    @game[:stats][:level]
  end

  def creep_score
    @game[:stats][:minionsKilled] || 0
  end

  def neutral_minions
    @game[:stats][:neutralMinionsKilled] || 0
  end

  def neutral_minions_enemy
    @game[:stats][:neutralMinionsKilledEnemy] || 0
  end

  def neutral_minions_friendly
    @game[:stats][:neutralMinionsKilledYourJungle] || 0
  end

  def gold_earned
    @game[:stats][:goldEarned]
  end

  def gold_spent
    @game[:stats][:goldSpent]
  end

  def unspent_gold
    gold_earned - gold_spent
  end

  def inhibitors_destroyed
    @game[:stats][:barracksKilled] || 0
  end

  def towers_destroyed
    @game[:stats][:turretsKilled] || 0
  end

  def wards_placed
    @game[:stats][:wardPlaced] || 0
  end

  def vision_wards
    @game[:stats][:visionWardsBought] || 0
  end

  def wards_destroyed
    @game[:stats][:wardKilled] || 0
  end

  def total_healing
    @game[:stats][:totalHeal] || 0
  end

  def killing_sprees
    @game[:stats][:killingSprees] || 0
  end

  def largest_killing_spree
    @game[:stats][:largestKillingSpree] || 0
  end

  def largest_multi_kill
    @game[:stats][:largestMultiKill] || 0
  end

  def total_damage
    @game[:stats][:totalDamageDealt]
  end

  def total_damage_taken
    @game[:stats][:totalDamageTaken]
  end

  def physical_damage_dealt
    @game[:stats][:physicalDamageDealtPlayer]
  end

  def physical_damage_taken
    @game[:stats][:physicalDamageTaken]
  end

  def magic_damage_dealt
    @game[:stats][:magicDamageDealtPlayer]
  end

  def magic_damage_taken
    @game[:stats][:magicDamageTaken]
  end

  def true_damage_dealt
    @game[:stats][:trueDamageDealtPlayer]
  end

  def true_damage_taken
    @game[:stats][:trueDamageTaken]
  end

  def item_0
    Item.find_by(item_id: @game[:stats][:item0])
  end

  def item_1
    Item.find_by(item_id: @game[:stats][:item1])
  end

  def item_2
    Item.find_by(item_id: @game[:stats][:item2])
  end

  def item_3
    Item.find_by(item_id: @game[:stats][:item3])
  end

  def item_4
    Item.find_by(item_id: @game[:stats][:item4])
  end

  def item_5
    Item.find_by(item_id: @game[:stats][:item5])
  end

  def item_6
    Item.find_by(item_id: @game[:stats][:item6])
  end

end
