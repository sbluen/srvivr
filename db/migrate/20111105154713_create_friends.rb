class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :inviter_id
      t.integer :invitee_id
      t.boolean :confirmed

      t.timestamps
    end
  end
end
