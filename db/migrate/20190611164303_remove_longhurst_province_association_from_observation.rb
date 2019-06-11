class RemoveLonghurstProvinceAssociationFromObservation < ActiveRecord::Migration[6.0]
  def change
    remove_reference :observations, :longhurst_province, null: false, foreign_key: true
  end
end
