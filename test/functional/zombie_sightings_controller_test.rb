require 'test_helper'

class ZombieSightingsControllerTest < ActionController::TestCase
  setup do
    @zombie_sighting = zombie_sightings(:zombie)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zombie_sightings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zombie_sighting" do
    assert_difference('ZombieSighting.count') do
      post :create, zombie_sighting: @zombie_sighting.attributes
    end

    # TODO: Regex instead?
    assert_redirected_to zombie_sightings_path + "?notice=Zombie+sighting+was+successfully+created."
  end

  test "should show zombie_sighting" do
    get :show, id: @zombie_sighting.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @zombie_sighting.to_param
    assert_response :success
  end

  test "should update zombie_sighting" do
    put :update, id: @zombie_sighting.to_param, zombie_sighting: @zombie_sighting.attributes
    assert_redirected_to zombie_sighting_path(assigns(:zombie_sighting))
  end

  test "should destroy zombie_sighting" do
    assert_difference('ZombieSighting.count', -1) do
      delete :destroy, id: @zombie_sighting.to_param
    end

    assert_redirected_to zombie_sightings_path
  end
  
  test "near should return successfully and not be nil" do
    get :near
    assert_response :success
    assert_not_nil :zombie_sightings
  end

  test "near should return successfully with radius as param" do
    get :near, radius: 4
    assert_response :success
  end
end
