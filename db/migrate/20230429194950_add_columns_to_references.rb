class AddColumnsToReferences < ActiveRecord::Migration[7.0]
  def change
    add_column :references, :title, :string
    add_column :references, :journal, :string
    add_column :references, :volume, :string
    add_column :references, :issue, :string
    add_column :references, :part_supplement, :string
    add_column :references, :pages, :string
    add_column :references, :start_page, :integer
    add_column :references, :errata, :string
    add_column :references, :epub_date, :date
    add_column :references, :date, :date
    add_column :references, :author, :text
  end
end
