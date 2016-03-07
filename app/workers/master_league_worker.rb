class MasterLeagueWorker
  include Sidekiq::Worker

  def perform(user_id)
    @mlpb = MasterLeaguePlayerBuilder.new(user_id)
  end

end
