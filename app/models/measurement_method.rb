class MeasurementMethod < ApplicationRecord
  include Describable

  belongs_to :trait_class
  validates :name, presence: true
end
