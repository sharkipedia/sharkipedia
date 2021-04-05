class AddSpeciesToMeasurements < ActiveRecord::Migration[6.1]
  def up
    add_reference :measurements, :species, null: true, foreign_key: true

    puts "Updating #{Observation.count} observations with #{Measurement.count} measurements"

    Observation.find_each do |observation|
      observation.measurements.update_all species_id: observation.species_id

      print "."
    end

    puts
    puts "Done."
    change_column_null :measurements, :species_id, false
  end

  def down
    puts "NOTE: Removing the species association from Measurements leads to data loss!"
    puts "The species of the first measurement of the observation will be associated."
    puts "Updating #{Observation.count} observations with #{Measurement.count} measurements"

    Observation.find_each do |observation|
      next if observation.measurements.blank?
      observation.update species_id: observation.measurements.first.species_id

      print "."
    end

    puts
    puts "Done."
    remove_reference :measurements, :species
  end
end
