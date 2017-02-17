module ApplicationHelper
  
  def logged_in?
    return User.find_by_id(session[:user_id])
  end

  def logged_in_as_admin?
    if not User.find_by_id(session[:user_id]) then return false end #If you're not logged in then you're not an admin.
    return User.find_by_id(session[:user_id]).usertype == "admin"
  end

  def hidden_div_if(condition, attributes = {}, &block)
    if condition
    attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  def nearby_recent_sightings
   # recent_sightings = Array.new
    sightings = ZombieSighting.find_by_sql("SELECT * FROM locations ORDER BY created_at DESC LIMIT 5;")
   # sightings.each do |sighting|
    #    if Time.now.to_i - sighting.created_at.to_i < 900
     #         recent_sightings.push sighting
     #   end
     # end
    return sightings
  end

  def is_nearby(user, sighting)
    return Math.sqrt( (user.lng-sighting.lng)^2 + (user.lat-sighting.lng)^2 ) < 5000
  end
  
  def get_image_path_for_profile(profile)
    if profile.image_url.blank? then
      return ['m', 'M'].include?(profile.gender) ? 'unknown_male.jpg' : 'unknown_female.jpg'
    else
      return profile.image_url
    end
  end
end
