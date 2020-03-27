class Trend < ApplicationRecord
  belongs_to :user
  belongs_to :reference
  belongs_to :species
  belongs_to :location
  belongs_to :ocean
  belongs_to :data_type
  belongs_to :standard
  belongs_to :sampling_method

  has_many :trend_observations, -> { order(:year) }, dependent: :destroy

  has_one_attached :figure

  accepts_nested_attributes_for :trend_observations, allow_destroy: true

  validates :start_year, presence: true
  validates :end_year, presence: true

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[year value]
      observations_data.each do |data_pair|
        csv << data_pair
      end
    end
  end

  def observations_data
    trend_observations.map do |trend_observation|
      [trend_observation.year, trend_observation.value]
    end
  end

  def create_or_update_observations observations
    incoming_years = observations.map(&:first)
    existing = trend_observations.map(&:year)
    to_remove = existing - incoming_years

    trend_observations.where(year: to_remove).destroy_all

    observations.each do |year, value|
      observation = trend_observations.where(year: year).first
      if observation
        observation.update(value: value)
      else
        trend_observations.create(year: year, value: value)
      end
    end
  end
end
