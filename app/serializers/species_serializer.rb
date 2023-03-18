# == Schema Information
#
# Table name: species
#
#  id                    :bigint           not null, primary key
#  authorship            :string
#  cites_status          :integer          default("none")
#  cites_status_year     :string
#  cms_status            :integer          default("none")
#  cms_status_year       :string
#  edge_scientific_name  :string
#  iucn_code             :string
#  name                  :string           not null
#  scientific_name       :string
#  slug                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  species_data_type_id  :bigint
#  species_family_id     :bigint
#  species_order_id      :bigint
#  species_subclass_id   :bigint
#  species_superorder_id :bigint
#
# Indexes
#
#  index_species_on_slug                   (slug)
#  index_species_on_species_data_type_id   (species_data_type_id)
#  index_species_on_species_family_id      (species_family_id)
#  index_species_on_species_order_id       (species_order_id)
#  index_species_on_species_subclass_id    (species_subclass_id)
#  index_species_on_species_superorder_id  (species_superorder_id)
#
# Foreign Keys
#
#  fk_rails_...  (species_data_type_id => species_data_types.id)
#  fk_rails_...  (species_family_id => species_families.id)
#  fk_rails_...  (species_order_id => species_orders.id)
#  fk_rails_...  (species_subclass_id => species_subclasses.id)
#
class SpeciesSerializer < BaseSerializer
  attribute :binomial_name, &:name

  attributes :edge_scientific_name, :iucn_code, :authorship

  has_many :observations
  has_many :measurements
  has_many :trends
end
