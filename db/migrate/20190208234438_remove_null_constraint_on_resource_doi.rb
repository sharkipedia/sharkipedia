class RemoveNullConstraintOnResourceDoi < ActiveRecord::Migration[5.2]
  def change
    change_column_null :resources, :doi, true
  end
end
