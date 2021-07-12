class AddLinkToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :qr_code_link, :text
    add_column :users, :file_link, :text
  end
end
