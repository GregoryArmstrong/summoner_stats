require 'net/http'
require 'json'
require 'faraday'

class RiotService

  attr_reader :user, :connection

  def initialize(user)
    @user = User.find(user) if user.class == Fixnum
    @user = user if user.class == User
    @connection = Faraday.new(url: "https://#{@user.region.downcase}.api.pvp.net" ) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def summoner_id
    parse(connection_settings("api/lol/#{user.region.downcase}/v1.4/summoner/by-name/#{user.summoner_name}"))
  end

  def recent_games(player)
    parse(connection_settings("api/lol/#{player.region.downcase}/v1.3/game/by-summoner/#{player.summoner_id}/recent"))
  end

  def all_champions
    parse(connection_settings("api/lol/#{user.region.downcase}/v1.2/champion"))
  end

  def single_champion_info(champion)
    parse(connection.get do |req|
      req.url "api/lol/static-data/#{user.region.downcase}/v1.2/champion/#{champion.champion_id}"
      req.params['champData'] = 'all'
      req.params['api_key'] = ENV['riot_api_key']
    end)
  end

  def all_items
    parse(connection_settings("api/lol/static-data/#{user.region.downcase}/v1.2/item"))
  end

  def master_league_players_info
    parse(connection.get do |req|
      req.url "api/lol/na/v2.5/league/master"
      req.params['type'] = 'RANKED_SOLO_5x5'
      req.params['api_key'] = ENV['riot_api_key']
    end)
  end

  private

  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def connection_settings(path)
    connection.get do |req|
      req.url path
      req.params['api_key'] = ENV['riot_api_key']
    end
  end
end
