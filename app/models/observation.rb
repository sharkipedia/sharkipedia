class Observation < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :resources
  belongs_to :species
  belongs_to :longhurst_province
  belongs_to :location

  has_many :measurements
end
