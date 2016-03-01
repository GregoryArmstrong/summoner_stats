class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)

    flash[:success] = "Account Created"
    redirect_to user_path(user)
  end

  def show
    @user = User.find(params[:id])
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
