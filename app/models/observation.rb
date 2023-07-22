# == Schema Information
#
# Table name: observations
#
#  id             :bigint           not null, primary key
#  access         :string
#  depth          :string
#  hidden         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contributor_id :string
#  import_id      :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_observations_on_import_id  (import_id)
#  index_observations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (import_id => imports.id)
#  fk_rails_...  (user_id => users.id)
#
class Observation < ApplicationRecord
  belongs_to :user
  belongs_to :import

  has_and_belongs_to_many :references

  has_many :measurements, dependent: :destroy
  accepts_nested_attributes_for :measurements, allow_destroy: true

  has_many :species, -> { distinct }, through: :measurements

  has_many :longhurst_provinces, through: :measurements
  has_many :locations, through: :measurements

  default_scope { order(created_at: :asc) }
  scope :published, -> { where(hidden: [false, nil]) }

  validates :references, presence: true

  def title
    species_names = species.map(&:name).join(", ")
    references_names = references.map(&:name).join(", ")

    [species_names, references_names].reject(&:blank?).join(" - ")
  end

  def published?
    !hidden?
  end

  def toggle_publish_state
    update(hidden: !hidden?)
  end
end
