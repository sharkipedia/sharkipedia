class MarineEcoregionsWorld < ApplicationRecord
  validates :region_type, presence: true
  validates :province, presence: true

  has_and_belongs_to_many :trends

  scope :ppow, -> { where(region_type: "PPOW") }
  scope :meow, -> { where(region_type: "MEOW") }
end
