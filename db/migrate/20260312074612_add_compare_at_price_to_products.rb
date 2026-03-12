class AddCompareAtPriceToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :compare_at_price, :decimal
  end
end
