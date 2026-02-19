# app/channels/reviews_channel.rb
class ReviewsChannel < ApplicationCable::Channel
  def subscribed
    stream_name = "reviews_for_decor_item_#{params[:decor_item_id]}"
    puts "[CHANNEL] User subscribed to #{stream_name}"
    stream_from stream_name
  end

  def unsubscribed
    puts "[CHANNEL] User unsubscribed from reviews channel"
    # Any cleanup needed when channel is unsubscribed
  end
end