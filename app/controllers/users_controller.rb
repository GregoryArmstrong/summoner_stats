class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.valid?
      session[:user_id] = @user.id
      flash[:success] = "Account Created"
      Presenter.new(@user).show_summoner_id
      MasterLeagueWorker.perform_async(@user.id)
      redirect_to user_path(@user)
    else
      flash[:notice] = "Invalid User"
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
    @presenter = Presenter.new(@user) unless @user.summoner_name_and_region_absent?
    if @presenter
      @games = @presenter.recent_games(@user)
      @games_averages = @presenter.recent_games_averages(@user).averages
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)

    redirect_to user_path(@user)
  end

  def clear
    Rails.cache.clear("gamedataaverages-#{params[:id]}")
    redirect_to user_path(params[:user])
  end

  private

  def user_params
    params.require(:user).permit(:name, :summoner_name, :region, :password, :password_confirmation)
  end

end
