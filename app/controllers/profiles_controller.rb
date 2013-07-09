class ProfilesController < ApplicationController

  #You have to be an admin to edit or create a new profile using this controllers.
  skip_before_filter :require_admin, only: [:show]
  before_filter :require_user

  #def require_profile_self_or_admin
  #  if (logged_in? && User.find(session[:user_id]).profile.id == params[:id]) || require_admin
  #    return true
  #  else
  #    return false
  #  end
  #end

  # GET /profiles
  # GET /profiles.json
  #No longer used.
  def index
    search
    @my_friends=Profile.where(["user_id IN (SELECT invitee_id FROM friends WHERE confirmed = 1 AND inviter_id = ? " +
      " UNION SELECT inviter_id FROM friends WHERE confirmed = 1 AND invitee_id = ?)", 
      session[:user_id], session[:user_id]]).order(:username)
    @my_friend_invites=Profile.where(["user_id IN (SELECT invitee_id FROM friends WHERE confirmed = 0 AND inviter_id = ? " +
      " UNION SELECT inviter_id FROM friends WHERE confirmed = 1 AND invitee_id = ?)", 
      session[:user_id], session[:user_id]]).order(:username)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])
    #NOTE: Due to a mysql bug, we can't put parentheses around the clauses joined by the union.
    @friends=User.includes(:profile).where(["id IN (SELECT invitee_id FROM friends WHERE confirmed = 1 AND inviter_id = ? " +
      " UNION SELECT inviter_id FROM friends WHERE confirmed = 1 AND invitee_id = ?)",
      @profile.user_id, @profile.user_id]).paginate(:page => params[:page]).order('name')
    @my_friends=User.where(["id IN (SELECT invitee_id FROM friends WHERE confirmed = 1 AND inviter_id = ?) " +
      " OR id IN (SELECT inviter_id FROM friends WHERE confirmed = 1 AND invitee_id = ?)",
      session[:user_id], session[:user_id]])
    @my_friend_invites=User.where(["id IN (SELECT invitee_id FROM friends WHERE confirmed = 0 AND inviter_id = ?) " +
      " OR id IN (SELECT inviter_id FROM friends WHERE confirmed = 0 AND invitee_id = ?)",
      session[:user_id], session[:user_id]])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = Profile.new
    @profile.user_id = session[:user_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
      @profile = Profile.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(params[:profile])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])

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

  # POST /updatelocation.json
  def updatelocation
    profile = Profile.find(2)
    profile.update_attributes(:lat => params[:lat], :lng => params[:lng])

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :ok }
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :ok }
    end
  end
  
  #Helper for index method.
  #No longer used.
  def search
    @profiles=Profile.search(params[:search]).sort_by {|profile|profile.username}
  end
end

