class Ocean < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
