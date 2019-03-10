class RemoveTypeNullConstraintOnImports < ActiveRecord::Migration[5.2]
  def change
    change_column_null :imports, :import_type, true
  end
end
