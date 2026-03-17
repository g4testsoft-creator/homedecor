class Api::V1::ProductsController < Api::V1::BaseController 
  def index
    @products = Product.order(created_at: :desc)
    products_data = @products.map do |product|
      {
        id: product.id,
        name: product.name,
        price: product.price,
        image_url: product.images.attached? ? url_for(product.images.first) : nil
      }
    end
    render json: products_data
  end

  def show
    @product = Product.find(params[:id])
    product_data = {
      id: @product.id,
      name: @product.name,
      description: @product.description,
      price: @product.price,
      image_url: @product.images.attached? ? url_for(@product.images.first) : nil
    }
    render json: product_data
  end
end