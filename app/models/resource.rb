class Resource < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :observations
  has_many :trends
end
