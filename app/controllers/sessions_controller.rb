class SessionsController < ApplicationController

  #This controller is for logins.
  skip_before_filter :bounce_zombies
  skip_before_filter :require_admin

  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:number_of_friend_invites] = Friend.count(:all, 
        :conditions => ['confirmed = 0 AND invitee_id = ?', user.id])
      redirect_back_or_default
      flash[:notice] = "Logged in"
    else
      redirect_to login_url, alert: "Invalid username/password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
    flash[:notice] = "Logged out"
  end

end

