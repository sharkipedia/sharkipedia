# == Schema Information
#
# Table name: marine_ecoregions_worlds
#
#  id           :bigint           not null, primary key
#  geom         :geometry         multipolygon, 4326
#  province     :string           not null
#  region_type  :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  trend_reg_id :integer
#
# Indexes
#
#  index_marine_ecoregions_worlds_on_geom  (geom) USING gist
#
class MarineEcoregionsWorld < ApplicationRecord
  validates :region_type, presence: true
  validates :province, presence: true

  has_and_belongs_to_many :trends

  scope :ppow, -> { where(region_type: "PPOW") }
  scope :meow, -> { where(region_type: "MEOW") }
end
