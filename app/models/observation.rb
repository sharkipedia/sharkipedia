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
end
