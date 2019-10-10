class ChangeLocationValuesToStrings < ActiveRecord::Migration[6.0]
  def up
    change_column :locations, :lat, :string
    change_column :locations, :lon, :string
  end

  def down
    change_column :locations, :lat, "decimal USING lat::numeric(15,10)"
    change_column :locations, :lon, "decimal USING lat::numeric(15,10)"
  end
end
