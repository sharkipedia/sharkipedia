class Location < ApplicationRecord
  has_many :measurements
  has_many :observations, through: :measurements
  has_many :trends

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
                                   using: {
                                     tsearch: {
                                       prefix: true
                                     }
                                   }

  def longitude
    lonlat.try :x || lon
  end

  def latitude
    lonlat.try :y || lat
  end

  def display
    if name.blank?
      "lat: #{latitude}, long: #{longitude}"
    else
      name
    end
  end
end
