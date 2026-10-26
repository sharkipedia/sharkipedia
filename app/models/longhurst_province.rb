# == Schema Information
#
# Table name: longhurst_provinces
#
#  id         :bigint           not null, primary key
#  code       :string
#  geom       :geometry         multipolygon, 4326
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_longhurst_provinces_on_code  (code)
#  index_longhurst_provinces_on_geom  (geom) USING gist
#
class LonghurstProvince < ApplicationRecord
  include RegionGeometry

  # Points just outside every polygon (on the coastline, or on the
  # antimeridian seam) fall back to the nearest province within this distance.
  NEAREST_TOLERANCE_DEGREES = 1.0

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  has_many :measurements
  has_many :observations, through: :measurements

  # The province containing the given point, or failing that the nearest one
  # within NEAREST_TOLERANCE_DEGREES.
  def self.containing(longitude:, latitude:)
    return if longitude.blank? || latitude.blank?

    point = sanitize_sql_array(["ST_SetSRID(ST_MakePoint(?, ?), 4326)", longitude.to_f, latitude.to_f])
    with_geom
      .where("ST_DWithin(geom, #{point}, ?)", NEAREST_TOLERANCE_DEGREES)
      .order(Arel.sql("ST_Distance(geom, #{point}), id"))
      .first
  end
end
