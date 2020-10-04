class AddLonLatToLocation < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :lonlat, :st_point, srid: 4326, geographic: true
  end
end
