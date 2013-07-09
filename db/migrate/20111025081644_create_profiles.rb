class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :age
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
