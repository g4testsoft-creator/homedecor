# Guest cart item for session-based shopping carts
# Provides the same interface as CartItem but for unauthenticated users

class GuestCartItem
  attr_accessor :decor_item, :quantity

  def initialize(decor_item, quantity)
    @decor_item = decor_item
    @quantity = quantity
  end

  def total_price
    decor_item.price * quantity
  end

  def id
    decor_item.id
  end

  def decor_item_id
    decor_item.id
  end

  # Make it compatible with Rails rendering
  def persisted?
    false
  end

  def to_key
    nil
  end
end
