class EezSerializer < BaseSerializer
  attribute :id, :fid

  attributes :name, :area_km2

  attributes :territory1, :sovereign1, :iso_ter1, :iso_sov1
  attributes :territory2, :sovereign2, :iso_ter2, :iso_sov2
  attributes :territory3, :sovereign3, :iso_ter3, :iso_sov3
end
