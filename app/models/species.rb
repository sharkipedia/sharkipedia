class Species < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
    using: {
    tsearch: {
      prefix: true
    }
  }

  validates :name, presence: true, uniqueness: true

  belongs_to :species_superorder
  belongs_to :species_data_type
  belongs_to :species_subclass
  belongs_to :species_order
  belongs_to :species_family
  has_many :observations
  has_many :trends
end
