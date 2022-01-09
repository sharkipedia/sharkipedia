module ObservationsHelper
  def link_to_add_measurement_fields(name, f)
    new_measurement = f.object.measurements.klass.new
    new_measurement.location = Location.new

    id = new_measurement.object_id
    fields = f.fields_for(:measurements, new_measurement, child_index: id) { |builder|
      render("measurement_fields", f: builder)
    }
    link_to(name, "#", class: "add_fields", data: {id:, fields: fields.delete("\n")})
  end

  def format_location location
    if location.latitude.blank? && location.longitude.blank?
      location.name
    else
      "#{location.name} (#{location.latitude},#{location.longitude})"
    end
  end
end
