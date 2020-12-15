class ObservationSerializer < BaseSerializer
  attributes :depth

  attribute :references do |object|
    object.references.map(&:name)
  end

  has_many :measurements

  belongs_to :species
end
