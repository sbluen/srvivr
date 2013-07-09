class AddFriendController < ApplicationController
  skip_before_filter :require_admin
  def create
    other_id=params[:other_id].to_i()
    my_id=session[:user_id]
    if my_id<other_id then
      small_id=my_id
      big_id=other_id
    elsif my_id>other_id then
      small_id=other_id
      big_id=my_id
    else
      flash[:notice] = "There was an error adding the friend."
      #redirect_to request.referrer
      return
    end
    if Friend.new({:inviter_id => my_id, :invitee_id => other_id, :small_id => small_id, 
      :big_id => big_id, :confirmed => false}).save() then
      flash[:notice] = "Added friend successfully."
    else
      flash[:notice] = "There was an error adding the friend."
    end
    redirect_to request.referrer
  end
  
  #This method is needed because otherwise, rails fails to use the create method no matter what I do.
  def index
    logger.info { "Rails fails to use the prespecified create method automatically." }
    create
  end
end