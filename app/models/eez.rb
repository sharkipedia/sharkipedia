# == Schema Information
#
# Table name: eez_v11
#
#  area_km2   :float
#  fid        :integer          not null, primary key
#  geom       :geometry         multipolygon, 4326
#  geoname    :string(80)
#  iso_sov1   :string(80)
#  iso_sov2   :string(80)
#  iso_sov3   :string(80)
#  iso_ter1   :string(80)
#  iso_ter2   :string(80)
#  iso_ter3   :string(80)
#  mrgid      :float
#  mrgid_eez  :float
#  mrgid_sov1 :float
#  mrgid_sov2 :float
#  mrgid_sov3 :float
#  mrgid_ter1 :float
#  mrgid_ter2 :float
#  mrgid_ter3 :float
#  pol_type   :string(80)
#  sovereign1 :string(80)
#  sovereign2 :string(80)
#  sovereign3 :string(80)
#  territory1 :string(80)
#  territory2 :string(80)
#  territory3 :string(80)
#  un_sov1    :bigint
#  un_sov2    :bigint
#  un_sov3    :bigint
#  un_ter1    :bigint
#  un_ter2    :bigint
#  un_ter3    :bigint
#  x_1        :float
#  y_1        :float
#
# Indexes
#
#  eez_v11_geom_geom_idx  (geom) USING gist
#
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
