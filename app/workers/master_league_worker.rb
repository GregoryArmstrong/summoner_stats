class MasterLeagueWorker
  include Sidekiq::Worker

  def perform(user)
    binding.pry
    @mlpb = MasterLeaguePlayerBuilder.new(user)
    @mlpb.master_league_players_info
  end

end
