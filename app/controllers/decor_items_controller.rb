class DecorItemsController < ApplicationController
  def index
    @decor_items = DecorItem.all.order(created_at: :desc)
  end

  def show
    @decor_item = DecorItem.find(params[:id])
  end
end

