class Resource < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :observations
  has_many :trends

  validates :doi, format: {
    with: /\A10.\d{4,9}\/[-._;()\/:A-Z0-9]+\z/i,
    message: 'malformed, please follow specification.' }, allow_blank: true

  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
    using: {
    tsearch: {
      prefix: true
    }
  }
end
