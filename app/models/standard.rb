class Standard < ApplicationRecord
  include Describable

  belongs_to :trait_class, optional: true
  validates :name, presence: true

  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true
                                     }
                                   }
end
