class RenameDecorItemsToProducts < ActiveRecord::Migration[7.0]
  def change
    # Rename the main table
    rename_table :decor_items, :products
    
    # Rename foreign key columns in related tables
    rename_column :reviews, :decor_item_id, :product_id
    rename_column :cart_items, :decor_item_id, :product_id
    
    # Rename indexes in reviews table
    remove_index :reviews, [:decor_item_id, :user_id] if index_exists?(:reviews, [:decor_item_id, :user_id])
    
    remove_index :reviews, :decor_item_id if index_exists?(:reviews, :decor_item_id)
    
    # Rename indexes in cart_items table
    remove_index :cart_items, [:cart_id, :decor_item_id] if index_exists?(:cart_items, [:cart_id, :decor_item_id])
    
    remove_index :cart_items, :decor_item_id if index_exists?(:cart_items, :decor_item_id)
    
    # Update foreign keys
    remove_foreign_key :reviews, :decor_items if foreign_key_exists?(:reviews, :decor_items)
    # add_foreign_key :reviews, :products
    
    remove_foreign_key :cart_items, :decor_items if foreign_key_exists?(:cart_items, :decor_items)
    # add_foreign_key :cart_items, :products
  end
end
