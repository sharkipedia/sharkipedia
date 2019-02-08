class TraitClass < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :traits
  has_many :standards
end
