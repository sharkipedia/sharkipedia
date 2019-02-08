class ValueType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
