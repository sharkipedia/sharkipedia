class SpeciesOrder < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :species_superorder
  belongs_to :species_subclass
end
