class AddResourceFilePublicFlagToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :file_public, :boolean
  end
end
