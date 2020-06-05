class RenameTaxonomicNotesToCommentsOnTrends < ActiveRecord::Migration[6.0]
  def change
    rename_column :trends, :taxonomic_notes, :comments
  end
end
