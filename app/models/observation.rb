class Observation < ApplicationRecord
  belongs_to :user, optional: true

  has_and_belongs_to_many :resources
  belongs_to :species
  belongs_to :longhurst_province, optional: true
  belongs_to :location

  has_many :measurements, dependent: :destroy
end
