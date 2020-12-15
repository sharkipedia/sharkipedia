class TrendObservationSerializer < BaseSerializer
  attributes :year, :value
  belongs_to :trend
end
