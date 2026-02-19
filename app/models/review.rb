# app/models/review.rb
class Review < ApplicationRecord
  belongs_to :decor_item
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, presence: true
  validates :decor_item_id, presence: true

  after_create_commit :broadcast_review

  private

  def broadcast_review
    # Broadcast to all users viewing this decor item
    puts "[BROADCAST] Starting broadcast for decor_item_#{decor_item_id}"
    puts "[BROADCAST] Review ID: #{id}, User: #{user.email}"
    
    stream_name = "reviews_for_decor_item_#{decor_item_id}"
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
      locals: { review: self, decor_item: decor_item, current_user: nil }
    )
    puts "[RENDER_REVIEW] HTML length: #{html.length}"
    html
  end

  def render_rating
    puts "[RENDER_RATING] Rendering rating partial for decor_item #{decor_item_id}"
    html = ApplicationController.renderer.render(
      partial: "decor_items/rating",
      locals: { decor_item: decor_item }
    )
    puts "[RENDER_RATING] HTML length: #{html.length}"
    html
  end
end