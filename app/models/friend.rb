class Friend < ActiveRecord::Base
  #source of idea: http://blog.hasmanythrough.com/2007/10/30/self-referential-has-many-through
  belongs_to :inviter,    :class_name => "User"
  belongs_to :invitee,    :class_name => "User"
  self.per_page = 100 
  
  #special because it shouldn't overwrite anthing.
  def create_special
    
  end
end
