class Unit < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
