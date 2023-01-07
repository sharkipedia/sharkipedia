# == Schema Information
#
# Table name: sex_types
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SexType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
