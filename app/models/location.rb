class Location < ApplicationRecord
  has_many :measurements
  has_many :observations, through: :measurements

  include PgSearch
  pg_search_scope :search_by_name, against: [:name],
    using: {
    tsearch: {
      prefix: true
    }
  }

  def display
    if name.blank?
      "lat: #{lat}, long: #{lon}"
    else
      name
    end
  end
end
