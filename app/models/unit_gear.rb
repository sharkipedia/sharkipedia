class UnitGear < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
