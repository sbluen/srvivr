#require 'ruby-debug'
class UsersController < ApplicationController

  #skip_before_filter :require_admin, only: [:create, :index, :new]
  skip_before_filter :require_admin
  before_filter :require_user, only: [:index]

  def require_user_self_or_admin
    if (logged_in? && session[:user_id] == params[:id]) || require_admin
      return true
    else
      return false
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users=User.search(params[:search], params[:page])
    @my_friends=User.where(["id IN (SELECT invitee_id FROM friends WHERE confirmed = 1 AND inviter_id = ?) " +
      " OR id IN (SELECT inviter_id FROM friends WHERE confirmed = 1 AND invitee_id = ?)", 
      session[:user_id], session[:user_id]])
    @my_friend_invites=User.where(["id IN (SELECT invitee_id FROM friends WHERE confirmed = 0 AND inviter_id = ?) " +
      " OR id IN (SELECT inviter_id FROM friends WHERE confirmed = 0 AND invitee_id = ?)", 
      session[:user_id], session[:user_id]])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    #@profile = Profile.find(@user.id)

    respond_to do |format|
      # redirect to profile show page
      #format.html { redirect_to @profile }
      format.html
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    #debugger
      if @user.save and not @user.errors.any?
        @user.update_attribute(:usertype, "member")
        session[:user_id] = @user.id
                  @profile = Profile.create(user_id: @user.id, age: 0, gender: 'm', username: @user.name)
          @profile.save
          flash[:notice] = 'User account has been successfully created, redirect to profile edit page.'
        redirect_to '/edit_my_profile'
      else
        render action: "new"
      end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {
          redirect_back_or_default
          flash[:notice] = 'User was successfully updated.'
        }
        format.json { head :ok }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors,
        status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    #This logic is needed to avoid an unbound variable exception
    #if (not session[:user_results].nil?) and (session[:user_results].include? @user) then
    #  session[:user_results].delete_if{|item| item==@user}
    #end
    @user.destroy

    respond_to do |format|
      format.html { redirect_back_or_default }
      format.json { head :ok }
    end
  end
end

