# == Schema Information
#
# Table name: analysis_models
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AnalysisModel < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :trends
end
