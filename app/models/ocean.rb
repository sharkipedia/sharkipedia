class Ocean < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :trends
end
