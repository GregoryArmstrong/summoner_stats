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

  private

  def user_params
    params.require(:user).permit(:name, :summoner_name, :region)
  end

end
