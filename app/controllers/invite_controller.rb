class InviteController < ApplicationController
  skip_before_filter :require_admin
  def accept
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
      redirect_to request.referrer
      return
    end
    #NOTE: Don't copy and reuse the delete_all method for tables whose rows are dependencies.
    if  Friend.where(["(small_id=? AND big_id=?)",
       small_id, big_id]).first.update_attribute(:confirmed, true) then
      flash[:notice] = "Added friend successfully."
      session[:number_of_friend_invites]-=1
    else
      flash[:notice] = "There was an error adding the friend."
    end
    respond_to do |format|
      format.html { render :nothing => true }
      format.js   { render :nothing => true }
    end
  end
  
  #This breaks the DRY principle, but the alternatives aren't obvious.
  def reject
    other_id=params[:other_id].to_i()
    my_id=session[:user_id]
    if my_id<other_id then
      small_id=my_id
      big_id=other_id
    elsif my_id>other_id then
      small_id=other_id
      big_id=my_id
    else
      flash[:notice] = "There was an removing the friend."
      redirect_to request.referrer
      return false
    end
    #NOTE: Don't copy and reuse the delete_all method for tables whose rows are dependencies.
    if  Friend.destroy_all(["(small_id=? AND big_id=?)",
       small_id, big_id]) then
      flash[:notice] = "Removed friend successfully."
      #redirect_to request.referrer
      return true
    else
      flash[:notice] = "There was an error removing the friend."
      redirect_to request.referrer
      return false
    end
      session[:number_of_friend_invites]-=1
  end
  
  def refuse
    flash[:params]=params
    reject
  end
  
  def decline
    flash[:params]=params
    reject
  end
end
