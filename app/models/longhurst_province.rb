class LonghurstProvince < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  # TODO: add boundaries
  # TODO: add method that checks if a given (lat,long) is within the
  #       bounds of boundary

  has_many :observations
end
