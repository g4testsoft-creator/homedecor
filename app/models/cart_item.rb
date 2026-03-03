class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product, foreign_key: 'product_id'

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, uniqueness: { scope: :cart_id }

  def total_price
    product.price * quantity
  end
end
