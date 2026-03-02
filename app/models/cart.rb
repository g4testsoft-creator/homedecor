class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :decor_items, through: :cart_items

  def total_price
    cart_items.sum { |item| item.decor_item.price * item.quantity }
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def add_item(decor_item, quantity = 1)
    cart_item = cart_items.find_or_initialize_by(decor_item_id: decor_item.id)
    if cart_item.new_record?
      cart_item.quantity = quantity
    else
      cart_item.quantity += quantity
    end
    cart_item.save
    cart_item
  end

  def remove_item(decor_item)
    cart_items.find_by(decor_item_id: decor_item.id)&.destroy
  end

  def update_quantity(decor_item, quantity)
    cart_item = cart_items.find_by(decor_item_id: decor_item.id)
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
