class FaoArea < ApplicationRecord
  belongs_to :ocean
  validates :f_code, presence: true, uniqueness: true
  validates :f_level, presence: true
  validates :name, presence: true
end
