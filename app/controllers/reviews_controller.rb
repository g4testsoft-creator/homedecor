# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_decor_item

  def create
    @review = @decor_item.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      # The broadcast happens automatically via the model callback
      respond_to do |format|
        format.html { redirect_to @decor_item, notice: 'Review was successfully created.' }
        format.turbo_stream { render :create }
      end
    else
      respond_to do |format|
        format.html { redirect_to @decor_item, alert: 'Error creating review.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(
          "review-form-element",
          partial: "reviews/form",
          locals: { decor_item: @decor_item, review: @review }
        ) }
      end
    end
  end

  private

  def set_decor_item
    @decor_item = DecorItem.find(params[:decor_item_id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end