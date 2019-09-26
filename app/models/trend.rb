class Trend < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :species
  belongs_to :location
  belongs_to :ocean
  belongs_to :data_type
  belongs_to :standard
  belongs_to :sampling_method

  has_many :trend_observations, dependent: :destroy

  has_one_attached :figure

  accepts_nested_attributes_for :trend_observations, allow_destroy: true

  validates :start_year, presence: true
  validates :end_year, presence: true

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w{year value}
      trend_observations.order(:year).each do |trend_observation|
        csv << [trend_observation.year, trend_observation.value]
      end
    end
  end
end
