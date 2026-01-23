class DecorItemsController < ApplicationController
  def index
    @decor_items = DecorItem.all.order(created_at: :desc)
  end
end

