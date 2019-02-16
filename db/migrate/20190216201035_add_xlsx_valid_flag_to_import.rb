class AddXlsxValidFlagToImport < ActiveRecord::Migration[5.2]
  def change
    add_column :imports, :xlsx_valid, :boolean
  end
end
