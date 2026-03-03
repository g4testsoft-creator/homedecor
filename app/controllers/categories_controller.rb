class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(slug: params[:slug])
    @products = @category.products.order(created_at: :desc).page(params[:page]).per(12)
  end
end
