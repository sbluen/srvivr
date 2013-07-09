class ReportController < ApplicationController
  skip_before_filter :require_admin
  def create
    if params[:other_id]==session[:user_id]
      flash[:notice] = "You have been banned. Please contact an administrator for assistance."
      User.find(session[:user_id]).update_attribute(:usertype, "hacker")
      redirect_to request.referrer
      return
    end
    if User.find(params[:other_id]).update_attribute(:usertype, "zombie") then
      flash[:notice] = "Zombie reported successfully."
    else
      flash[:notice] = "Error reporting zombie."
    end
    redirect_to request.referrer
  end
  
  #This method is needed because otherwise, rails fails to use the create method no matter what I do.
  def index
    logger.info { "Rails fails to use the prespecified create method automatically." }
    create
  end
end
