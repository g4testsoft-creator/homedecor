# app/channels/reviews_channel.rb
class ReviewsChannel < ApplicationCable::Channel
  def subscribed
    stream_name = "reviews_for_product_#{params[:product_id]}"
    puts "[CHANNEL] User subscribed to #{stream_name}"
    puts "[CHANNEL] Available params: #{params.to_h}"
    stream_from stream_name
  end

  def unsubscribed
    puts "[CHANNEL] User unsubscribed from reviews channel"
    # Any cleanup needed when channel is unsubscribed
  end
end