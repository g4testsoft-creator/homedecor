# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy, foreign_key: 'product_id', primary_key: 'id'
  has_many_attached :images
  
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :compare_at_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :generate_slug, on: :create

  # Scopes
  scope :newest, -> { order(created_at: :desc).limit(10) }
  scope :in_stock, -> { where('quantity > 0') }
  scope :out_of_stock, -> { where(quantity: 0) }
  scope :low_stock, -> { where('quantity > 0 AND quantity <= 10') }
  
  scope :popular, -> { 
    left_joins(:reviews)
      .group(:id)
      .order('AVG(reviews.rating) DESC NULLS LAST, created_at DESC')
      .limit(10)
  }
  
  scope :trending, -> { 
    left_joins(:reviews)
      .group(:id)
      .order('COUNT(reviews.id) DESC, created_at DESC')
      .limit(10)
  }
  
  scope :by_category, ->(category_slug) { 
    joins(:category).where(categories: { slug: category_slug }) 
  }

  scope :search, ->(query) {
    if query.present?
      left_joins(:category)
        .where("products.name ILIKE ? OR categories.name ILIKE ?", "%#{query}%", "%#{query}%")
        .distinct
    else
      all
    end
  }
  
  scope :on_sale, -> { where('compare_at_price IS NOT NULL AND compare_at_price > price') }

  # Stock methods
  def in_stock?
    quantity > 0
  end
  
  def low_stock?
    quantity > 0 && quantity <= 10
  end
  
  def stock_status
    if quantity > 10
      "IN STOCK"
    elsif quantity > 0
      "LOW STOCK"
    else
      "OUT OF STOCK"
    end
  end
  
  def stock_status_class
    if quantity > 0
      "in-stock"
    else
      "out-of-stock"
    end
  end

  # Discount methods
  def on_sale?
    compare_at_price.present? && compare_at_price > price
  end
  
  def discount_percentage
    return 0 unless on_sale?
    ((compare_at_price - price) / compare_at_price * 100).round
  end

  # Rating methods
  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def review_count
    reviews.count
  end

  # Related products (you'll need to set up a join table for this)
  # For now, a simple implementation - products in same category
  def related_products(limit = 4)
    category.present? ? category.products.where.not(id: id).limit(limit) : []
  end

  # Features methods
  def feature_list
    features || {}
  end

  def has_features?
    features.present? && features.keys.any?
  end

  def to_param
    slug
  end

  private

  def generate_slug
    return if slug.present?
    base = name.to_s.parameterize
    base = "product" if base.blank?

    candidate = base
    i = 2
    while self.class.exists?(slug: candidate)
      candidate = "#{base}-#{i}"
      i += 1
    end

    self.slug = candidate
  end
end