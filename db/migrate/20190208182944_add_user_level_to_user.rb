class AddUserLevelToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_level, :string, default: 'user'
  end
end
