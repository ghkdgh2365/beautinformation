class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :product_name
      t.integer :price
      t.text :product_describe
      t.string :buy_link
      t.string :img

      t.timestamps
    end
  end
end
