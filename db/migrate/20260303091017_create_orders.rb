class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.decimal :subtotal
      t.decimal :tax
      t.decimal :total
      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_zip
      t.string :shipping_country
      t.string :email
      t.string :phone
      t.string :payment_method

      t.timestamps
    end
  end
end
