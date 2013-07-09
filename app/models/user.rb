class User < ActiveRecord::Base
  has_one :profile, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  has_secure_password
  before_destroy :ensure_not_referenced_by_any_profile
  
  #source of ideas: http://blog.hasmanythrough.com/2007/10/30/self-referential-has-many-through
  has_many :friends_as_inviter,   :foreign_key => 'inviter_id',
                                  :class_name => 'Friend',
                                  :dependent => :destroy
                       
  has_many :friends_as_invitee,   :foreign_key => 'invitee_id',
                                  :class_name => 'Friend',
                                  :dependent => :destroy
                                  
  self.per_page = 20
  def self.search(search, page=1)
    if search and search != '' then
      search_condition = "%" + search + "%"
      return includes(:profile).where(['name LIKE ?', search_condition]).paginate(:page => page).order('name')
    else
      #find(:all)
      return paginate(:page => page).order('name')
    end
  end

  def ensure_not_referenced_by_any_profile
    # TODO change dummy func
    return true
  end

end

