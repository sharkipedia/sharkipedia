class Trait < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true
                                     }
                                   }
  include Describable

  belongs_to :trait_class
  validates :name, presence: true

  has_many :measurements
end
