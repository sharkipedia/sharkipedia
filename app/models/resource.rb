class Resource < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :doi, presence: true, uniqueness: true
end
