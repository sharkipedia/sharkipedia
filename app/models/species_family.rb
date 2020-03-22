class SpeciesFamily < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true
                                     }
                                   }

  validates :name, presence: true, uniqueness: true

  belongs_to :species_subclass
  belongs_to :species_superorder
  belongs_to :species_order
end
