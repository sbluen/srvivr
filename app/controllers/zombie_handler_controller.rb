class ZombieHandlerController < ApplicationController
  skip_before_filter :bounce_zombies
  skip_before_filter :require_admin
  def index
    
  end
  def show
    
  end
end
