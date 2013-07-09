class RemoveFriendController < ApplicationController
  skip_before_filter :require_admin
  def delete
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
  end
end
