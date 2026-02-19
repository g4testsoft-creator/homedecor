class RemoveUniqueConstraintFromReviews < ActiveRecord::Migration[7.0]
  def change
    remove_index :reviews, [:decor_item_id, :user_id], unique: true
    add_index :reviews, [:decor_item_id, :user_id]
  end
end
