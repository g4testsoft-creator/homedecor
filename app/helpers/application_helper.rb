module ApplicationHelper
  def product_image_tag(product, options = {})
    if product.images.attached?
      image_tag product.images.first, options
    else
      # Fallback placeholder image
      image_tag "https://via.placeholder.com/400x300?text=No+Image", options
    end
  end
end
