class AddCategoryToDecorItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :decor_items, :category, foreign_key: true
  end
end