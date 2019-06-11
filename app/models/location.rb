class Location < ApplicationRecord
  has_many :observations, through: :measurements
  has_many :measurements

  def display
    if name.blank?
      "lat: #{lat}, long: #{lon}"
    else
      name
    end
  end
end
