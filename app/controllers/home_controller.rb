class HomeController < ApplicationController
  def index
    @newest_items = Product.order(created_at: :desc).limit(8)
    @categories = Category.all
  end
end