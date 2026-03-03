class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy, foreign_key: 'product_id', primary_key: 'id'
  has_one_attached :image
  
  validates :name, presence: true
  validates :image, presence: true

  scope :newest, -> { order(created_at: :desc).limit(10) }
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
  

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def review_count
    reviews.count
  end
end

