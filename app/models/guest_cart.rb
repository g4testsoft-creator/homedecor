class GuestCart
  attr_accessor :items

  def initialize(session_items = {})
    @items = session_items
  end

  def cart_items
    @items.map do |product_id, quantity|
      GuestCartItem.new(product_id, quantity)
    end
  end

  def total_price
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def total_items
    @items.values.sum
  end

  def add_item(product, quantity = 1)
    @items[product.id.to_s] = (@items[product.id.to_s].to_i || 0) + quantity
  end

  def remove_item(product)
    @items.delete(product.id.to_s)
  end

  def update_quantity(product, quantity)
    if quantity <= 0
      @items.delete(product.id.to_s)
    else
      @items[product.id.to_s] = quantity
    end
  end

  def clear
    @items.clear
  end
end

class GuestCartItem
  attr_reader :product_id, :quantity

  def initialize(product_id, quantity)
    # Ensure product_id is always an integer
    if product_id.is_a?(Product)
      @product_id = product_id.id
    elsif product_id.is_a?(String)
      @product_id = product_id.to_i
    else
      @product_id = product_id.to_i
    end
    @quantity = quantity.to_i
  end

  def product
    @product ||= Product.find(@product_id)
  end
end
