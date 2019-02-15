class Trend < ApplicationRecord
  belongs_to :user
  belongs_to :data_source
  belongs_to :species
  belongs_to :location
  belongs_to :ocean
  belongs_to :data_type
  belongs_to :unit
  belongs_to :sampling_method
end
