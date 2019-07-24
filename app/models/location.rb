class Location < ApplicationRecord
  has_many :measurements
  has_many :observations, through: :measurements

  def display
    if name.blank?
      "lat: #{lat}, long: #{lon}"
    else
      name
    end
  end
end
