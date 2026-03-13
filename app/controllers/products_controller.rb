class ProductsController < ApplicationController
  def index
    @products = Product.all.order(created_at: :desc)
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
end
