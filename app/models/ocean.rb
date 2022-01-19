class Ocean < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }

  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :trends
  has_many :species, through: :trends
end
