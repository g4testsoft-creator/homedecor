class CreateDecorItems < ActiveRecord::Migration[7.0]
  def change
    create_table :decor_items do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.string :image_url

      t.timestamps
    end
  end
end

