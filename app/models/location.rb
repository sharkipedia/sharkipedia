class Location < ApplicationRecord
  def display
    if name.blank?
      "lat: #{lat}, long: #{lon}"
    else
      name
    end
  end
end
