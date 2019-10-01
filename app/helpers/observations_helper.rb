module ObservationsHelper
  def link_to_add_measurement_fields(name, f)
    new_measurement = f.object.measurements.klass.new
    new_measurement.location = Location.new

    id = new_measurement.object_id
    fields = f.fields_for(:measurements, new_measurement, child_index: id) do |builder|
      render("measurement_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
