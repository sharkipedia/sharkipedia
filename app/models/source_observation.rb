# == Schema Information
#
# Table name: source_observations
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SourceObservation < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :trends
end
