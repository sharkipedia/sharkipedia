class SourceObservation < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
