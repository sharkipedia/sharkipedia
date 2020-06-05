class MarineEcoregionsWorld < ApplicationRecord
  validates :unep_fid, presence: true, uniqueness: true
  validates :region_type, presence: true
  validates :province, presence: true
end
