class AdminController < ApplicationController
  before_filter :require_admin

  def index
    #store_location
    search
  end

  #We don't do posts right now with this controller, so let's disable the create method.
  #def create
  #end

  def search
    @users = User.search params[:search]
  end
end

