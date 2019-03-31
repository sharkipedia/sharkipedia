class SpeciesSuperorder < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :species_subclass

  has_many :species
  has_many :species_orders
  has_many :species_families
end
