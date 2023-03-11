# == Schema Information
#
# Table name: species_groups
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SpeciesGroup < ApplicationRecord
  validates :name, presence: true
  has_and_belongs_to_many :species
  has_many :trends
end
