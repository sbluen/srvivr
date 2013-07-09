class Location < ActiveRecord::Base
  has_many :zombie_sightings
  has_many :users
end
