class LocationAddUid < ActiveRecord::Migration
  def change
    add_column :locations, :Source_plus_UID, :string
  end
end
