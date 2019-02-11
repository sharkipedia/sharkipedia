class Location < ApplicationRecord
  has_many :observations

  def display
    if name.blank?
      "lat: #{lat}, long: #{lon}"
    else
      name
    end
  end
end
