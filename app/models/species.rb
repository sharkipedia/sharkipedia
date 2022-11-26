class Species < ApplicationRecord
  enum cms_status: [:none, :appendix_1, :appendix_2], _prefix: true
  enum cites_status: [:none, :appendix_1, :appendix_2], _prefix: true

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

  has_many :measurements
  has_many :observations, through: :measurements
  has_many :trends

  has_and_belongs_to_many :species_groups

  def group_trends
    Trend.where(species_group: species_groups)
  end
end
