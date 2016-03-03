class ChampionsController < ApplicationController

  def index
    @free_champions = Champion.where(free_to_play: true)
  end

end
