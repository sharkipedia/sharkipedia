class SpeciesSubclass < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :species
  has_many :species_superorders
  has_many :species_orders
  has_many :species_families
end
