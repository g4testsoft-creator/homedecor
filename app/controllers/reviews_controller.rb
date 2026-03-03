# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      # The broadcast happens automatically via the model callback
      respond_to do |format|
        format.html { redirect_to @product, notice: 'Review was successfully created.' }
        format.turbo_stream { render :create }
      end
    else
      respond_to do |format|
        format.html { redirect_to @product, alert: 'Error creating review.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(
          "review-form-element",
          partial: "reviews/form",
          locals: { product: @product, review: @review }
        ) }
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end