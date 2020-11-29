class Eez < ApplicationRecord
  self.table_name = "eez_v11"
  self.primary_key = "fid"

  SERIALIZATION_FIELDS = %w[
    fid geoname area_km2
    territory1 sovereign1 iso_ter1 iso_sov1
    territory2 sovereign2 iso_ter2 iso_sov2
    territory3 sovereign3 iso_ter3 iso_sov3
  ]

  def self.select_without_geom
    select(*SERIALIZATION_FIELDS)
  end

  alias_attribute :name, :geoname
end
