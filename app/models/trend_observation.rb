class TrendObservation < ApplicationRecord
  belongs_to :trend

  validates :year, presence: true
  validates :value, presence: true
end
