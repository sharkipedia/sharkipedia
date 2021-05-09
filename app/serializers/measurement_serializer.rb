class MeasurementSerializer < BaseSerializer
  belongs_to :species

  attributes :value
  attribute :sex_type do |object|
    object.sex_type&.name
  end
  attribute :trait_class do |object|
    object.trait_class&.name
  end
  attribute :trait do |object|
    object.trait&.name
  end
  attribute :standard do |object|
    object.standard&.name
  end
  attribute :measurement_method do |object|
    object.measurement_method&.name
  end
  attribute :measurement_model do |object|
    object.measurement_model&.name
  end
  attribute :value_type do |object|
    object.value_type&.name
  end
  attribute :precision
  attribute :precision_type do |object|
    object.precision_type&.name
  end
  attribute :precision_upper
  attribute :sample_size
  attribute :dubious
  attribute :validated
  attribute :notes
  attribute :validation_type do |object|
    object.validation_type&.name
  end
  attribute :location do |object|
    object.location&.name
  end
  attribute :ocean do |object|
    object.location&.name
  end
  attribute :longhurst_province do |object|
    object.longhurst_province&.name
  end

  belongs_to :observation
end
