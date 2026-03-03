class MakeUserIdOptionalInOrders < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :user_id, :bigint, null: true
  end
end
