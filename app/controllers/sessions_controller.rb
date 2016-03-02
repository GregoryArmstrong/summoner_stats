class SessionsController < ApplicationController

  def new
  end

  def create
    if request.env["omniauth.auth"]
      @user = User.from_omniauth(request.env["omniauth.auth"])
      @user.save
    else
      @user = User.find_by(name: params[:session][:name])
    end
    if @user && (@user.provider || @user.authenticate(params[:session][:password]))
      session[:user_id] ||= @user.id
      redirect_to user_path(@user)
    else
      redirect_to root_path
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
