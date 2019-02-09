class Resource < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
