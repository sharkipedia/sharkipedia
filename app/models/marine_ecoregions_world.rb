class MarineEcoregionsWorld < ApplicationRecord
  validates :unep_fid, presence: true, uniqueness: true
  validates :region_type, presence: true
  validates :province, presence: true

  has_and_belongs_to_many :trends
end
