class DecorItem < ApplicationRecord
  has_many :reviews, dependent: :destroy
  
  validates :name, presence: true

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def review_count
    reviews.count
  end
end

