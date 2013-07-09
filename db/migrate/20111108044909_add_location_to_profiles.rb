class AddLocationToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :lat, :decimal, :precision => 15, :scale => 10
    add_column :profiles, :lng, :decimal, :precision => 15, :scale => 10
  end
end
