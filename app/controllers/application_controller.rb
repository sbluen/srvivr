require 'ruby-debug'
class ApplicationController < ActionController::Base
  protect_from_forgery

  #Get zombie sightings appearantly must be first.
  #skip_before_filter :require_admin,  only: [:show_friend_invites]
  before_filter :initialize_layout
  before_filter :bounce_zombies
  before_filter :require_admin
  
  skip_before_filter :require_admin,  only: [:show_friend_invites]

  #source: http://stackoverflow.com/questions/2592109/how-to-pass-a-javascript-variable-to-rails-controller
  def show_friend_invites
    Rails.logger.info "Caller friend invite showing method successfully."
    flash[:notice]="friends should now be displayed."
    respond_to do |format|
      #format.js {render request.referrer}
      format.js {redirect_back_or_default}
    end
  end

  def initialize_layout
    @zombie_sightings = ZombieSighting.all
    @friend_inviters=Friend.find(:all, :conditions=>['invitee_id=? AND confirmed = 0', session[:user_id]],
    :include => :inviter)
  end

  def bounce_zombies
    @user=User.find_by_id(session[:user_id])
    if @user and @user.usertype=='zombie' then
      redirect_to '/zombie_handler'
    end
  end

  #source: http://joshsharpe.com/archives/redirect-back-or-default-youre-probably-doing-it-wrong
  def require_user
    unless logged_in?
      store_location
      redirect_to login_path
      flash[:notice] = "Please log in first."
      return false
    end
  end

   def require_admin
    unless logged_in_as_admin?
      store_location
      redirect_to login_path
      flash[:notice] = "You are entering a restricted page. Please log in as an administrator first."
      session[:admin_required]=true
      return false
    end
  end

  def logged_in?
    return User.find_by_id(session[:user_id])
  end

  def logged_in_as_admin?
    if not User.find_by_id(session[:user_id]) then return false end #If you're not logged in then you're not an admin.
    return User.find_by_id(session[:user_id]).usertype == "admin"
  end

  #source: http://joshsharpe.com/archives/redirect-back-or-default-youre-probably-doing-it-wrong
  def redirect_back_or_default(default=:root)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


  private
  #source: http://joshsharpe.com/archives/redirect-back-or-default-youre-probably-doing-it-wrong
  def store_location
    session[:return_to] =
    if request.get?
      request.fullpath
    else
      request.referer
    end
  end
end

