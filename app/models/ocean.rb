class Ocean < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true
                                     }
                                   }

  validates :name, presence: true, uniqueness: true
  has_many :trends
end
