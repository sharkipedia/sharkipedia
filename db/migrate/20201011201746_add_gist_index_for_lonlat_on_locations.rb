class AddGistIndexForLonlatOnLocations < ActiveRecord::Migration[6.0]
  def change
    add_index :locations, :lonlat, using: :gist
  end
end
