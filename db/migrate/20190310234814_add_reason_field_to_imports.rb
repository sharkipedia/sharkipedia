class AddReasonFieldToImports < ActiveRecord::Migration[5.2]
  def change
    add_column :imports, :reason, :text
  end
end
