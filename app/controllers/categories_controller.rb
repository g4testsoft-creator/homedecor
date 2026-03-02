class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(slug: params[:slug])
    @decor_items = @category.decor_items.order(created_at: :desc).page(params[:page]).per(12)
  end
end
