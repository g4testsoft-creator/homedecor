class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_price
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def add_item(product, quantity = 1)
    cart_item = cart_items.find_or_initialize_by(product_id: product.id)
    if cart_item.new_record?
      cart_item.quantity = quantity
    else
      cart_item.quantity += quantity
    end
    cart_item.save
    cart_item
  end

  def remove_item(product)
    cart_items.find_by(product_id: product.id)&.destroy
  end

  def update_quantity(product, quantity)
    cart_item = cart_items.find_by(product_id: product.id)
    if cart_item
      if quantity <= 0
        cart_item.destroy
      else
        cart_item.update(quantity: quantity)
      end
    end
  end

  def clear
    cart_items.destroy_all
  end
end
