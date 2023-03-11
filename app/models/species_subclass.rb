# == Schema Information
#
# Table name: species_subclasses
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SpeciesSubclass < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :species
  has_many :species_superorders
  has_many :species_orders
  has_many :species_families
end
