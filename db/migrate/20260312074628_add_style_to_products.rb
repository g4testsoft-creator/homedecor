class AddStyleToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :style, :string
  end
end
