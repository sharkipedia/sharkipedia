class Observation < ApplicationRecord
  belongs_to :user
  belongs_to :import

  has_and_belongs_to_many :references
  belongs_to :species

  has_many :measurements, dependent: :destroy
  accepts_nested_attributes_for :measurements, allow_destroy: true

  has_many :longhurst_provinces, through: :measurements
  has_many :locations, through: :measurements

  scope :published, -> { where(hidden: [false, nil]) }

  validates :references, presence: true
  validates :species, presence: true

  def title
    "#{species.name} - #{references.map(&:name)}"
  end
end
