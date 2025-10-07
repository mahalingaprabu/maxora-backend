class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :stock
      t.string :image_url
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
