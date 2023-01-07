# == Schema Information
#
# Table name: longhurst_provinces
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_longhurst_provinces_on_code  (code)
#
class LonghurstProvince < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  # TODO: add boundaries
  # TODO: add method that checks if a given (lat,long) is within the
  #       bounds of boundary

  has_many :measurements
  has_many :observations, through: :measurements
end
