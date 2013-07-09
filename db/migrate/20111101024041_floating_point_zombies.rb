class FloatingPointZombies < ActiveRecord::Migration
  def change
    change_column :locations, :lat, :decimal, :precision => 15, :scale => 10
    change_column :locations, :lng, :decimal, :precision => 15, :scale => 10
  end
end
