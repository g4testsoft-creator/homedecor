class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:decor_item)
  end

  def add_item
    decor_item = DecorItem.find(params[:decor_item_id])
    quantity = params[:quantity].to_i.positive? ? params[:quantity].to_i : 1
    
    @cart.add_item(decor_item, quantity)
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cart_count", partial: "cart_count")
      end
      format.html do
        redirect_to cart_path, notice: "Item added to cart!"
      end
    end
  end

  def remove_item
    decor_item = DecorItem.find(params[:decor_item_id])
    @cart.remove_item(decor_item)
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_items_list", partial: "cart_items_list", locals: { cart_items: @cart.cart_items.includes(:decor_item) }),
          turbo_stream.replace("cart_count", partial: "cart_count"),
          turbo_stream.replace("cart_total", partial: "cart_total")
        ]
      end
      format.html do
        redirect_to cart_path, notice: "Item removed from cart!"
      end
    end
  end

  def update_quantity
    decor_item = DecorItem.find(params[:decor_item_id])
    quantity = params[:quantity].to_i
    
    @cart.update_quantity(decor_item, quantity)
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_items_list", partial: "cart_items_list", locals: { cart_items: @cart.cart_items.includes(:decor_item) }),
          turbo_stream.replace("cart_count", partial: "cart_count"),
          turbo_stream.replace("cart_total", partial: "cart_total")
        ]
      end
      format.html do
        redirect_to cart_path, notice: "Quantity updated!"
      end
    end
  end

  def clear
    @cart.clear
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_items_list", partial: "cart_items_list", locals: { cart_items: [] }),
          turbo_stream.replace("cart_count", partial: "cart_count"),
          turbo_stream.replace("cart_total", partial: "cart_total")
        ]
      end
      format.html do
        redirect_to cart_path, notice: "Cart cleared!"
      end
    end
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end
end
