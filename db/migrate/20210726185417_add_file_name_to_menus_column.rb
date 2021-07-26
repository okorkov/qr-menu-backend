class AddFileNameToMenusColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :menus, :file_name, :string
  end
end
