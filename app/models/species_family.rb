class SpeciesFamily < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :species_subclass
  belongs_to :species_superorder
  belongs_to :species_order
end
