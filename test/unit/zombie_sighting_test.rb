require 'test_helper'

class ZombieSightingTest < ActiveSupport::TestCase
  test "near should return zombies sightings near a specific location" do
    my_location = Location.new(lat: 250, lng: 250)

    assert_equal 1, ZombieSighting.near(radius: 1, location: my_location).size,
                 "Should have been 1 zombie near me.."


    assert_equal 2, ZombieSighting.near(radius: 2, location: my_location).size,
                 "Should have been 2 zombie near me.."

  end

  test "near should work if lng is negative" do
    my_location = locations(:ucsb)
    assert_equal 2, ZombieSighting.near(radius: 4, location: my_location).size,
                 "Should have been 2 zombies near UCSB"

  end
end
