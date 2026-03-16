class OrderMailer < ApplicationMailer
  default from: 'noreply@homedecor.com'

  def order_confirmation(order)
    @order = order
    @order_items = order.order_items
    mail(to: @order.email, subject: "Order Confirmation - ##{@order.id}")
  end
end
