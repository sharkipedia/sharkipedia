# == Schema Information
#
# Table name: trend_observations
#
#  id         :bigint           not null, primary key
#  value      :string           not null
#  year       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trend_id   :bigint
#
# Indexes
#
#  index_trend_observations_on_trend_id  (trend_id)
#
# Foreign Keys
#
#  fk_rails_...  (trend_id => trends.id)
#
class TrendObservation < ApplicationRecord
  belongs_to :trend

  validates :year, presence: true
end
