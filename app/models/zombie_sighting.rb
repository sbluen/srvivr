class ZombieSighting < ActiveRecord::Base

  # Doesn't really use radius, more like a square
  def self.near(args)
    args[:radius] = 0.5 if (args[:radius].nil?)
    zombies = []
    radius = args[:radius]
    location = args[:location]

    # TODO: Optimize! Goes through EVERY zombie sightings...
    all.each do |zombie|
       if in_between(left: location.lng - radius,
                     right: location.lng + radius,
                     point: zombie.lng) and \
          in_between(left: location.lat - radius,
                     right: location.lat + radius,
                     point: zombie.lat)

          zombies << zombie

       end
    end
    return zombies
  end

  private
  def self.in_between(args)
    t = (args[:left] <= args[:point] and args[:point] <= args[:right])
    return t
  end
end
