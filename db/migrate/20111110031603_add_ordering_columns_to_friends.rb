class AddOrderingColumnsToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :small_id, :integer
    add_column :friends, :big_id, :integer
  end
end
