class AddQrLinks < ActiveRecord::Migration[6.1]
  def change
    add_column :links, :qr_code_link, :text
  end
end
