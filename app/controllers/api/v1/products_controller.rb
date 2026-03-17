class Api::V1::ProductsController < Api::V1::BaseController 
  def index
    @products = Product.order(created_at: :desc)
    render json: @products.as_json(only: [:id, :name, :price])
  end

  def show
    @product = Product.find(params[:id])
    render json: @product.as_json(only: [:id, :name, :description, :price])
  end
end