# == Schema Information
#
# Table name: species_data_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SpeciesDataType < ApplicationRecord
  has_many :species
end
