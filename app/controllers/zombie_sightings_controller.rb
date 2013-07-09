class ZombieSightingsController < ApplicationController

  skip_before_filter :require_admin, only: [:index, :show]
  before_filter :require_user

  # GET /zombie_sightings
  # GET /zombie_sightings.json
  def index
    #Moving this to the application controller because this isn't called by a partial rendering.
    #@zombie_sightings = ZombieSighting.all

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @zombie_sightings }
    end
  end

  # GET /zombie_sightings/1
  # GET /zombie_sightings/1.json
  def show
    @zombie_sighting = ZombieSighting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @zombie_sighting }
    end
  end

  # GET /zombie_sightings/new
  # GET /zombie_sightings/new.json
  def new
    @zombie_sighting = ZombieSighting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @zombie_sighting }
    end
  end

  # GET /zombie_sightings/1/edit
  def edit
    @zombie_sighting = ZombieSighting.find(params[:id])
  end

  # POST /zombie_sightings
  # POST /zombie_sightings.json

  def create
    @zombie_sighting = ZombieSighting.new(lat: params[:lat],
                                          lng: params[:lng])

    respond_to do |format|
      if @zombie_sighting.save
        format.html { redirect_to action: "index", notice: 'Zombie sighting was successfully created.' }
        format.json { render json: @zombie_sighting, status: :created, location: @zombie_sighting }
      else
        format.html {   render action: "new" }
        format.json { render json: @zombie_sighting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /zombie_sightings/1
  # PUT /zombie_sightings/1.json
  def update
    @zombie_sighting = ZombieSighting.find(params[:id])

    respond_to do |format|
      if @zombie_sighting.update_attributes(params[:zombie_sighting])
        format.html { redirect_to @zombie_sighting, notice: 'Zombie sighting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @zombie_sighting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zombie_sightings/1
  # DELETE /zombie_sightings/1.json
  def destroy
    @zombie_sighting = ZombieSighting.find(params[:id])
    @zombie_sighting.destroy

    respond_to do |format|
      format.html { redirect_to zombie_sightings_url }
      format.json { head :ok }
    end
  end

  def near
    user = User.find(session[:user_id])
    location = Location.new(lat: user.lat, lng: user.lng)

    radius = params[:radius]
    if radius.nil?
      radius = 1.0
    else
      radius = radius.to_f
    end

    @zombie_sightings = ZombieSighting.near(location: location, radius: radius)

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @zombie_sightings }
    end
  end
end
