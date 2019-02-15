class SamplingMethod < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
