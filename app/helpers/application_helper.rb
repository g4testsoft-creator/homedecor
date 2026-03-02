module ApplicationHelper
  def decor_item_image_tag(decor_item, options = {})
    if decor_item.image.attached?
      image_tag decor_item.image, options
    else
      # Fallback placeholder image
      image_tag "https://via.placeholder.com/400x300?text=No+Image", options
    end
  end
end
