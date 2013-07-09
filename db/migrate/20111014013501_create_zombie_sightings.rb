class CreateZombieSightings < ActiveRecord::Migration
  def change
    create_table :zombie_sightings do |t|
      t.references :location

      t.timestamps
    end
  end
end
