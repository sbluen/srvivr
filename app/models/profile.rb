class Profile < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :gender, presence: true
  validates :age, numericality: {
    greater_than_or_equal_to: 0,
    message: 'must be greater than or equal to 0.'
  }
  validates :age, numericality: {
    less_than: 150,
    message: 'must be less than 150.'
  }
  validates :gender, inclusion: {
    in: %w( m f M F),
    message: 'must be M (for male) or F (for female).'
  }
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)$}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

    #source: https://we.riseup.net/rails/simple-search-tutorial
  def self.search(search)
    if search and search != '' then
      search_condition = "%" + search + "%"
      return find(:all, :conditions => ['username LIKE ?', search_condition], :order=>'username')
    else
      #find(:all)
      #return {}
      first(100)
    end
  end

end

