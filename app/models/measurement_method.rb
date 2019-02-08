class MeasurementMethod < ApplicationRecord
  belongs_to :trait_class
  validates :name, presence: true
end
