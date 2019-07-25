class Trend < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :species
  belongs_to :location
  belongs_to :ocean
  belongs_to :data_type
  belongs_to :standard
  belongs_to :sampling_method

  has_many :trend_observations, dependent: :destroy

  accepts_nested_attributes_for :trend_observations
end
