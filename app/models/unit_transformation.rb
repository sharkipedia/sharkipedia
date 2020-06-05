class UnitTransformation < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
