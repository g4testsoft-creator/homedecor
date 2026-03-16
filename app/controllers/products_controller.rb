class ProductsController < ApplicationController
  def index
    @sort = params[:sort] || 'newest'
    @products = apply_sort(@sort)
  end

  def search
    @query = params[:q]
    @products = if @query.present?
                  Product.search(@query).order(created_at: :desc)
                else
                  []
                end

    respond_to do |format|
      format.json { render json: @products.as_json(only: [:id, :name, :price]) }
      format.html { redirect_to search_products_path(q: params[:q]) }
    end
  end

  def show
    @product = Product.find(params[:id])
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
    else
      Product.order(created_at: :desc)
    end
  end
end
