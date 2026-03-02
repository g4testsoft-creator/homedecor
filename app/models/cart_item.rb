class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :decor_item

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :decor_item_id, uniqueness: { scope: :cart_id }

  def total_price
    decor_item.price * quantity
  end
end
