class AddDateFieldToMeasurements < ActiveRecord::Migration[6.0]
  def up
    add_column :measurements, :date, :string

    Observation.all.each do |observation|
      # NOTE: the resulting data will be incorrect since measurements can have
      # different dates. Additional steps need to be take in to fix the faulty
      # records.
      observation.measurements.update_all date: observation.date
    end
  end

  def down
    remove_column :measurements, :date
  end
end
