# == Schema Information
#
# Table name: species_orders
#
#  id                    :bigint           not null, primary key
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  species_subclass_id   :bigint
#  species_superorder_id :bigint
#
# Indexes
#
#  index_species_orders_on_species_subclass_id    (species_subclass_id)
#  index_species_orders_on_species_superorder_id  (species_superorder_id)
#
# Foreign Keys
#
#  fk_rails_...  (species_subclass_id => species_subclasses.id)
#  fk_rails_...  (species_superorder_id => species_superorders.id)
#
class SpeciesOrder < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :species_superorder
  belongs_to :species_subclass

  has_many :species_families
end
