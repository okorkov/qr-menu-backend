class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :address
      t.integer :user_id

      t.timestamps
    end
  end
end
