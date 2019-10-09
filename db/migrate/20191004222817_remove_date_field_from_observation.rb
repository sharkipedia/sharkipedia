class RemoveDateFieldFromObservation < ActiveRecord::Migration[6.0]
  def up
    remove_column :observations, :date, :string
  end

  def down
    add_column :observations, :date, :string

    # NOTE: the resulting data will be incorrect since measurements can have
    # different dates. The previous schema was wrong.
    Observation.all.each do |observation|
      observation.update date: observation.measurements.first.date
    end
  end
end
