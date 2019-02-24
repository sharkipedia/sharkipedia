class ValidationType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
