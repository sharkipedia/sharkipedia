class Species < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true
                                     }
                                   }

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true

  belongs_to :species_superorder
  belongs_to :species_data_type
  belongs_to :species_subclass
  belongs_to :species_order
  belongs_to :species_family

  has_many :observations
  has_many :trends

  has_and_belongs_to_many :species_groups

  def group_trends
    Trend.where(species_group: species_groups)
  end
end
