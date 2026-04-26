module ApplicationHelper
  def product_image_tag(product, options = {})
    if product.images.attached?
      image_tag product.images.first, options
    else
      # Fallback placeholder image
      image_tag "https://via.placeholder.com/400x300?text=No+Image", options
    end
  end

  def format_price(amount)
    number_to_currency(amount, unit: "Rs. ", precision: 0, separator: "")
  end

  def cart_quantity_for(product)
    return 0 if product.blank?

    if user_signed_in? && current_user.cart.present?
      current_user.cart.cart_items.find_by(product_id: product.id)&.quantity.to_i
    elsif !user_signed_in? && session[:cart_items].present?
      session[:cart_items][product.id.to_s].to_i
    else
      0
    end
  end
end
