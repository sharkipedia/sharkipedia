# == Schema Information
#
# Table name: trait_classes
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TraitClass < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :traits
  has_many :standards
  has_many :measurement_methods
  has_many :measurement_models
end
