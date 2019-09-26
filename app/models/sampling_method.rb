class SamplingMethod < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
    using: {
    tsearch: {
      prefix: true
    }
  }
end
