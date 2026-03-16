class OrdersController < ApplicationController
  before_action :load_cart, only: [:checkout, :create, :create_payment_intent]
  before_action :load_order, only: [:confirmation]

  def checkout
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty'
      return
    end

    @order = Order.new
    @order.email = current_user&.email
    @stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end

  def create_payment_intent
    begin
      amount = params[:amount].to_i
      email = params[:email]

      if amount <= 0
        render json: { error: 'Invalid amount' }, status: :unprocessable_entity
        return
      end

      intent = Stripe::PaymentIntent.create(
        amount: amount,
        currency: 'usd',
        receipt_email: email,
        metadata: {
          order_id: 'pending'
        }
      )

      render json: { 
        client_secret: intent.client_secret,
        intent_id: intent.id
      }
    rescue Stripe::CardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue Stripe::RateLimitError
      render json: { error: 'Too many requests. Please try again.' }, status: :unprocessable_entity
    rescue Stripe::InvalidRequestError => e
      render json: { error: "Invalid request: #{e.message}" }, status: :unprocessable_entity
    rescue Stripe::AuthenticationError
      render json: { error: 'Authentication error.' }, status: :unprocessable_entity
    rescue Stripe::APIConnectionError
      render json: { error: 'Network error. Please try again.' }, status: :unprocessable_entity
    rescue Stripe::StripeError => e
      render json: { error: "Payment error: #{e.message}" }, status: :unprocessable_entity
    end
  end
  def create
    @order = Order.new(order_params)
    @order.status = 'pending'
    @order.subtotal = @cart.total_price
    @order.tax = calculate_tax(@order.subtotal)
    @order.total = @order.subtotal + @order.tax
    
    payment_method = params[:payment_method] || 'card'
    @order.payment_method = payment_method

    if payment_method == 'card'
      # Process Stripe payment
      return process_stripe_payment(@order, params[:payment_intent_id])
    elsif @order.save
      create_order_items
      @cart.clear
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

  def process_stripe_payment(order, payment_intent_id)
    begin
      if payment_intent_id.present?
        # Confirm the payment intent
        intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
        
        if intent.status.in?(%w[succeeded processing])
          unless order.save
            render :checkout, status: :unprocessable_entity
            return
          end
          create_order_items
          @cart.clear
          
          return redirect_to confirmation_order_path(order), notice: 'Payment successful! Order placed.'
        else
          return redirect_to checkout_orders_path, alert: 'Payment was not completed. Please try again.'
        end
      else
        return redirect_to checkout_orders_path, alert: 'Payment information is missing. Please try again.'
      end
    rescue Stripe::CardError => e
      return redirect_to checkout_orders_path, alert: "Payment failed: #{e.message}"
    rescue Stripe::RateLimitError
      return redirect_to checkout_orders_path, alert: 'Too many requests. Please try again later.'
    rescue Stripe::InvalidRequestError => e
      return redirect_to checkout_orders_path, alert: "Invalid request: #{e.message}"
    rescue Stripe::AuthenticationError
      return redirect_to checkout_orders_path, alert: 'Authentication error. Please contact support.'
    rescue Stripe::APIConnectionError
      return redirect_to checkout_orders_path, alert: 'Network error. Please try again.'
    rescue Stripe::StripeError => e
      return redirect_to checkout_orders_path, alert: "Payment error: #{e.message}"
    rescue StandardError => e
      return redirect_to checkout_orders_path, alert: "An error occurred: #{e.message}"
    end
  end
end
