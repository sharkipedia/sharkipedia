class SpeciesSuperorder < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :species
end
