class MeasurementModel < ApplicationRecord
  belongs_to :trait_class
  validates :name, presence: true
end
