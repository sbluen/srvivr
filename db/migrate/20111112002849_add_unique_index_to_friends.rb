class AddUniqueIndexToFriends < ActiveRecord::Migration
  def change
    #source: http://stackoverflow.com/questions/880981/in-a-join-table-whats-the-best-workaround-for-rails-absence-of-a-composite-ke
    add_index :friends, [ :small_id, :big_id ], :unique => true, :name => 'by_small_and_big'
  end
end
