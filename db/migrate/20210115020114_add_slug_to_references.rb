class AddSlugToReferences < ActiveRecord::Migration[6.0]
  def up
    add_column :references, :slug, :string
    add_index :references, :slug

    Reference.find_each do |r|
      r.save
      print "."
    end
    puts

    change_column_null :references, :slug, false
  end

  def down
    remove_column :references, :slug
  end
end
