class DataType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
