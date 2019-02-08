class TraitClass < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :traits
end
