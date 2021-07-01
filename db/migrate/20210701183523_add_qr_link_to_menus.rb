class AddQrLinkToMenus < ActiveRecord::Migration[6.1]
  def change
    add_column :menus, :qr_code_link, :text
  end
end
