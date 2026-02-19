class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :decor_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :content

      t.timestamps
    end
    
    add_index :reviews, [:decor_item_id, :user_id], unique: true
  end
end
