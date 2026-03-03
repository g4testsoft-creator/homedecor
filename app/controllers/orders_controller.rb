class OrdersController < ApplicationController
  before_action :load_cart, only: [:checkout, :create]
  before_action :load_order, only: [:confirmation]

  def checkout
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty'
      return
    end

    @order = Order.new
    @order.email = current_user&.email
  end

  def create
    @order = Order.new(order_params)
    @order.status = 'pending'
    @order.payment_method = 'cash_on_delivery'
    @order.subtotal = @cart.total_price
    @order.tax = calculate_tax(@order.subtotal)
    @order.total = @order.subtotal + @order.tax

    if @order.save
      create_order_items
      @cart.clear
      
      # Create user if not signed in (optional, for future reference)
      # store_order_session(@order.id)
      
      redirect_to confirmation_order_path(@order), notice: 'Order placed successfully'
    else
      render :checkout, status: :unprocessable_entity
    end
  end

  def confirmation
    # Allow both authenticated and guest users to view confirmation
    # For guests, we just need the order ID to be valid
  end

  private

  def load_cart
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
    else
      # Use session-based cart for guests
      @cart = GuestCart.new(session[:cart_items] ||= {})
    end
  end

  def load_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :email, :phone,
      :shipping_address, :shipping_city, :shipping_state, :shipping_zip, :shipping_country
    )
  end

  def create_order_items
    @cart.cart_items.each do |cart_item|
      if cart_item.is_a?(CartItem)
        product = cart_item.product
        quantity = cart_item.quantity
      elsif cart_item.is_a?(GuestCartItem)
        product = cart_item.product
        quantity = cart_item.quantity
      else
        product = Product.find(cart_item[:product_id])
        quantity = cart_item[:quantity]
      end
      
      @order.order_items.create(
        product_id: product.id,
        quantity: quantity,
        unit_price: product.price
      )
    end
  end

  def calculate_tax(subtotal)
    (subtotal * 0.08).round(2)  # 8% tax rate
  end
end
