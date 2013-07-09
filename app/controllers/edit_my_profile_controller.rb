class EditMyProfileController < ApplicationController
  skip_before_filter :require_admin
  before_filter :require_user
  def index
    @profile = Profile.where(['user_id = ?', session[:user_id]])[0]
  end
  
  #Copied from the profiles controller. The difference here is that there are different filters.
  def update
    @profile = Profile.find(:first, :conditions => [ "user_id = :id", { :id => session[:user_id] }])
    #This is an alternative to the find method
    #.where('user_id = ?', session[:user_id])[0]

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end
end
