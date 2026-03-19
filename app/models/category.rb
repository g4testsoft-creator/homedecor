class Category < ApplicationRecord
  has_many :products, dependent: :nullify
  
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  
  before_validation :generate_slug, on: :create
  
  # Predefined categories
  NEWEST = 'newest'
  POPULAR = 'popular'
  TRENDING = 'trending'
  
  def self.create_default_categories
    categories = [
      { name: 'Newest Arrivals', slug: NEWEST, description: 'Recently added products' },
      { name: 'Most Popular', slug: POPULAR, description: 'Highly rated by our community' },
      { name: 'Trending Now', slug: TRENDING, description: 'What everyone is talking about' },
      { name: 'Living Room', slug: 'living-room', description: 'Decor for your living space' },
      { name: 'Bedroom', slug: 'bedroom', description: 'Cozy bedroom decor' },
      { name: 'Kitchen', slug: 'kitchen', description: 'Kitchen and dining decor' },
      { name: 'Office', slug: 'office', description: 'Home office inspiration' },
      { name: 'Outdoor', slug: 'outdoor', description: 'Garden and patio decor' }
    ]
    
    categories.each do |category_data|
      find_or_create_by(slug: category_data[:slug]) do |c|
        c.name = category_data[:name]
        c.description = category_data[:description]
      end
    end
  end

  def to_param
    slug
  end
  
  private
  
  def generate_slug
    return if slug.present?
    self.slug = name.parameterize if name.present?
  end
end