class AddGeomToMarineRegions < ActiveRecord::Migration[8.1]
  TABLES = %i[longhurst_provinces fao_areas marine_ecoregions_worlds]

  def change
    TABLES.each do |table|
      add_column table, :geom, :multi_polygon, srid: 4326
      add_index table, :geom, using: :gist
    end
  end
end
