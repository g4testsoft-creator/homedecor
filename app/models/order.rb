class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum status: { pending: 'pending', processing: 'processing', shipped: 'shipped', delivered: 'delivered', cancelled: 'cancelled' }

  validates :email, :phone, presence: true
  validates :shipping_address, :shipping_city, :shipping_state, :shipping_zip, :shipping_country, presence: true
  validates :status, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  def total_items
    order_items.sum(:quantity)
  end

  def order_number
    "ORD-#{id.to_s.rjust(6, '0')}"
  end
end
