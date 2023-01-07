# == Schema Information
#
# Table name: species_superorders
#
#  id                  :bigint           not null, primary key
#  name                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  species_subclass_id :bigint
#
# Indexes
#
#  index_species_superorders_on_species_subclass_id  (species_subclass_id)
#
# Foreign Keys
#
#  fk_rails_...  (species_subclass_id => species_subclasses.id)
#
class SpeciesSuperorder < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :species_subclass

  has_many :species
  has_many :species_orders
  has_many :species_families
end
