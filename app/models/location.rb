# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  lat        :string
#  lon        :string
#  lonlat     :geography        point, 4326
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_lonlat  (lonlat) USING gist
#
class Location < ApplicationRecord
  has_many :measurements
  has_many :observations, through: :measurements
  has_many :trends

  before_validation :set_lonlat

  # TODO: remove the lat & lon columns
  validates :lat, numericality: {greater_than_or_equal_to: -90,
                                 less_than_or_equal_to: 90}, allow_blank: true
  validates :lon, numericality: {greater_than_or_equal_to: -180,
                                 less_than_or_equal_to: 180}, allow_blank: true

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }

  def longitude
    lonlat.try :lon || lon
  end

  def latitude
    lonlat.try :lat || lat
  end

  def display
    if name.blank?
      "lat: #{latitude}, long: #{longitude}"
    else
      name
    end
  end

  private

  def set_lonlat
    if lat.present? && lon.present?
      self.lonlat = "POINT(#{lon} #{lat})"
    end
  end
end
