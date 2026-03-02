class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_cart, :guest_cart?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end

  # Get the current cart for either logged-in user or guest
  def current_cart
    if user_signed_in?
      current_user.cart || current_user.create_cart
    else
      # For guests, use session-based cart
      session[:cart_items] ||= {}
    end
  end

  # Check if the current user is a guest (not authenticated)
  def guest_cart?
    !user_signed_in?
  end

  # Ensure current_user is available in views (it is by default with Devise, but added for clarity)
  helper_method :current_user
end
