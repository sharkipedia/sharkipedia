class Measurement < ApplicationRecord
  belongs_to :observation
  belongs_to :sex_type
  belongs_to :trait_class
  belongs_to :trait
  belongs_to :standard, optional: true
  belongs_to :measurement_method, optional: true
  belongs_to :measurement_model, optional: true
  belongs_to :value_type, optional: true
  belongs_to :validation_type, optional: true
  belongs_to :precision_type, optional: true
end
