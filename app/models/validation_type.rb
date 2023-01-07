# == Schema Information
#
# Table name: validation_types
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ValidationType < ApplicationRecord
  include Describable
  validates :name, presence: true, uniqueness: true
end
