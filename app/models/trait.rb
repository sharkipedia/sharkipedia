class Trait < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true,
                                     },
                                   }

  belongs_to :trait_class
  validates :name, presence: true

  has_many :measurements

  def name_with_description
    "#{name}#{ description.blank? ? '' : ' - ' }#{description}"
  end
end
