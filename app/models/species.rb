class Species < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :species_superorder
  belongs_to :species_data_type
  has_many :observations
end
