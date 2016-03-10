class MasterLeagueWorker
  include Sidekiq::Worker

  def perform(user_id)
    MasterLeaguePlayerBuilder.new(user_id)
  end

end
