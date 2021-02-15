class SpeciesSerializer < BaseSerializer
  attribute :binomial_name, &:name
  attribute :binomial_name do |obj|
    obj.name
  end

  attributes :edge_scientific_name, :iucn_code, :authorship

  # :family, :order, :subclass, :superorder

  # belongs_to :species_superorder
  # belongs_to :species_data_type
  # belongs_to :species_subclass
  # belongs_to :species_order
  # belongs_to :species_family

  has_many :observations
  has_many :trends
end
