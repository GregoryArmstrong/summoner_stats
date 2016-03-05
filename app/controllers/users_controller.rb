class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)

    flash[:success] = "Account Created"
    Presenter.new(user).show_summoner_id
    redirect_to user_path(user)
  end

  def show
    @user = User.find(params[:id])
    unless @user.summoner_name.nil? || @user.region.nil?
      @presenter = Presenter.new(@user)
    end
    if @presenter
      @games = @presenter.recent_games(@user)
      @games_averages = @presenter.recent_games_averages(@user).averages
    end
    # MasterLeagueWorker.perform_async(@user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)

    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :summoner_name, :region, :password, :password_confirmation)
  end

end
