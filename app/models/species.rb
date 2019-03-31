class Species < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :species_superorder
  belongs_to :species_data_type
  belongs_to :species_subclass
  has_many :observations
end
