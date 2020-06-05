class UnitTime < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
