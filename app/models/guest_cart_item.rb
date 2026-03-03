# Guest cart item for session-based shopping carts
# Provides the same interface as CartItem but for unauthenticated users

class GuestCartItem
  attr_accessor :product, :quantity

  def initialize(product, quantity)
    @product = product
    @quantity = quantity
  end

  def total_price
    product.price * quantity
  end

  def id
    product.id
  end

  def product_id
    product.id
  end

  # Make it compatible with Rails rendering
  def persisted?
    false
  end

  def to_key
    nil
  end
end
