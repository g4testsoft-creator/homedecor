class CartsController < ApplicationController
  before_action :set_cart, except: [:show]

  def show
    if user_signed_in?
      @cart_items = current_user.cart&.cart_items&.includes(:decor_item) || []
    else
      # Build cart items from session for guest users
      @cart_items = build_guest_cart_items
    end
  end

  def add_item
    decor_item = DecorItem.find(params[:decor_item_id])
    quantity = params[:quantity].to_i.positive? ? params[:quantity].to_i : 1
    
    if user_signed_in?
      @cart.add_item(decor_item, quantity)
    else
      add_item_to_guest_cart(decor_item, quantity)
    end
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cart_count", partial: "carts/cart_count")
      end
      format.html do
        redirect_to cart_path, notice: "Item added to cart!"
      end
    end
  end

  def remove_item
    decor_item = DecorItem.find(params[:decor_item_id])
    
    if user_signed_in?
      @cart.remove_item(decor_item)
      cart_items = @cart.cart_items.includes(:decor_item)
    else
      remove_item_from_guest_cart(decor_item)
      cart_items = build_guest_cart_items
    end
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_items_list", partial: "cart_items_list", locals: { cart_items: cart_items }),
          turbo_stream.replace("cart_count", partial: "carts/cart_count"),
          turbo_stream.replace("cart_total", partial: "cart_total", locals: { cart_items: cart_items })
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
    
    if user_signed_in?
      @cart.update_quantity(decor_item, quantity)
      cart_items = @cart.cart_items.includes(:decor_item)
    else
      update_guest_cart_quantity(decor_item, quantity)
      cart_items = build_guest_cart_items
    end
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_items_list", partial: "cart_items_list", locals: { cart_items: cart_items }),
          turbo_stream.replace("cart_count", partial: "carts/cart_count"),
          turbo_stream.replace("cart_total", partial: "cart_total", locals: { cart_items: cart_items })
        ]
      end
      format.html do
        redirect_to cart_path, notice: "Quantity updated!"
      end
    end
  end

  def clear
    if user_signed_in?
      @cart.clear
    else
      clear_guest_cart
    end
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("cart_items_list", partial: "cart_items_list", locals: { cart_items: [] }),
          turbo_stream.replace("cart_count", partial: "carts/cart_count"),
          turbo_stream.replace("cart_total", partial: "cart_total", locals: { cart_items: [] })
        ]
      end
      format.html do
        redirect_to cart_path, notice: "Cart cleared!"
      end
    end
  end

  private

  def set_cart
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
    end
  end

  # Guest cart methods using session storage

  def add_item_to_guest_cart(decor_item, quantity)
    cart_items = session[:cart_items] ||= {}
    item_id = decor_item.id.to_s
    
    if cart_items[item_id]
      cart_items[item_id] += quantity
    else
      cart_items[item_id] = quantity
    end
  end

  def remove_item_from_guest_cart(decor_item)
    session[:cart_items]&.delete(decor_item.id.to_s)
  end

  def update_guest_cart_quantity(decor_item, quantity)
    cart_items = session[:cart_items] ||= {}
    item_id = decor_item.id.to_s
    
    if quantity <= 0
      cart_items.delete(item_id)
    else
      cart_items[item_id] = quantity
    end
  end

  def clear_guest_cart
    session[:cart_items] = {}
  end

  def build_guest_cart_items
    cart_items = session[:cart_items] ||= {}
    
    cart_items.map do |decor_item_id, quantity|
      decor_item = DecorItem.find_by(id: decor_item_id)
      next unless decor_item
      
      # Create a simple object that mimics CartItem behavior
      GuestCartItem.new(decor_item, quantity)
    end.compact
  end
end
