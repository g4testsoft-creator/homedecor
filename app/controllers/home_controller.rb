class HomeController < ApplicationController
  def index
    @categories = Category.all
    @sort = params[:sort] || 'newest'
    @newest_items = apply_sort(@sort).limit(8)
  end

  private

  def apply_sort(sort_type)
    case sort_type
    when 'price-low'
      Product.order(price: :asc)
    when 'price-high'
      Product.order(price: :desc)
    when 'name-asc'
      Product.order(name: :asc)
    when 'name-desc'
      Product.order(name: :desc)
    when 'rating'
      Product.left_joins(:reviews)
             .group('products.id')
             .select('products.*, COALESCE(AVG(reviews.rating), 0) as avg_rating')
             .order('avg_rating DESC, products.id DESC')
    when 'popular'
      Product.left_joins(:reviews)
             .group('products.id')
             .select('products.*, COUNT(reviews.id) as review_count')
             .order('review_count DESC, products.id DESC')
    when 'newest'
      Product.order(created_at: :desc)
    else
      Product.order(created_at: :desc)
    end
  end
end