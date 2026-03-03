# app/models/review.rb
class Review < ApplicationRecord
  belongs_to :product, foreign_key: 'product_id'
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, presence: true
  validates :product_id, presence: true

  after_create_commit :broadcast_review

  private

  def broadcast_review
    # Broadcast to all users viewing this product
    puts "[BROADCAST] Starting broadcast for product_#{product_id}"
    puts "[BROADCAST] Review ID: #{id}, User: #{user.email}"
    
    stream_name = "reviews_for_product_#{product_id}"
    broadcast_data = {
      action: "create",
      render_review: render_review,
      render_rating: render_rating
    }
    
    puts "[BROADCAST] Stream name: #{stream_name}"
    puts "[BROADCAST] Broadcast data keys: #{broadcast_data.keys}"
    
    ActionCable.server.broadcast(stream_name, broadcast_data)
    
    puts "[BROADCAST] Broadcast sent successfully!"
  end

  def render_review
    puts "[RENDER_REVIEW] Rendering review partial for review #{id}"
    html = ApplicationController.renderer.render(
      partial: "reviews/review",
      locals: { review: self, product: product, current_user: nil }
    )
    puts "[RENDER_REVIEW] HTML length: #{html.length}"
    html
  end

  def render_rating
    puts "[RENDER_RATING] Rendering rating partial for product #{product_id}"
    html = ApplicationController.renderer.render(
      partial: "products/rating",
      locals: { product: product }
    )
    puts "[RENDER_RATING] HTML length: #{html.length}"
    html
  end
end