class AddAasmStateToImport < ActiveRecord::Migration[5.2]
  def change
    add_column :imports, :aasm_state, :string
  end
end
