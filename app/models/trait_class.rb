class TraitClass < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :traits
  has_many :standards
  has_many :measurement_methods
  has_many :measurement_models
end
