class SpeciesSerializer < BaseSerializer
  attribute :binomial_name, &:name

  attributes :edge_scientific_name, :iucn_code, :authorship

  has_many :observations
  has_many :measurements
  has_many :trends
end
