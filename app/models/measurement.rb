class Measurement < ApplicationRecord
  belongs_to :observation
  belongs_to :sex_type
  belongs_to :trait_class
  belongs_to :trait
  belongs_to :standard
  belongs_to :measurement_method
  belongs_to :measurement_model
  belongs_to :value_type
  belongs_to :precision_type
end
