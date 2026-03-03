# db/seeds.rb
require "open-uri"

# Clear existing data (optional – remove if you don't want reset behavior)
Review.destroy_all
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all

puts "Seeding categories and products..."

categories_data = [
  {
    name: "Wall Art",
    slug: "wall-art",
    description: "Beautiful wall paintings and frames",
    items: [
      {
        name: "Abstract Canvas Painting",
        description: "Modern abstract splash painting for living rooms",
        price: 129.99,
        image_url: "https://images.unsplash.com/photo-1541961017774-22349e4a1262"
      },
      {
        name: "Minimalist Line Art Frame",
        description: "Elegant black and white line art decor",
        price: 59.99,
        image_url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee"
      }
    ]
  },
  {
    name: "Lighting",
    slug: "lighting",
    description: "Modern and classic decorative lighting",
    items: [
      {
        name: "Golden Pendant Lamp",
        description: "Luxury hanging splash-style pendant light",
        price: 199.99,
        image_url: "https://images.unsplash.com/photo-1519710164239-da123dc03ef4"
      },
      {
        name: "Modern Table Lamp",
        description: "Stylish bedside splash lamp",
        price: 89.99,
        image_url: "https://images.unsplash.com/photo-1507473885765-e6ed057f782c"
      }
    ]
  },
  {
    name: "Vases & Plants",
    slug: "vases-plants",
    description: "Decorative vases and artificial plants",
    items: [
      {
        name: "Ceramic Splash Vase",
        description: "Handcrafted ceramic vase with splash texture",
        price: 49.99,
        image_url: "https://images.unsplash.com/photo-1501004318641-b39e6451bec6"
      },
      {
        name: "Artificial Indoor Plant",
        description: "Realistic decorative indoor plant",
        price: 39.99,
        image_url: "https://images.unsplash.com/photo-1492724441997-5dc865305da7"
      }
    ]
  }
]

categories_data.each do |category_data|
  items = category_data.delete(:items)

  category = Category.find_or_create_by!(slug: category_data[:slug]) do |c|
    c.name = category_data[:name]
    c.description = category_data[:description]
  end

  items.each do |item_data|
    category.products.find_or_create_by!(name: item_data[:name]) do |item|
      item.description = item_data[:description]
      item.price = item_data[:price]
      item.image_url = item_data[:image_url]
      file = URI.open("#{item_data[:image_url]}?w=800")
      item.image.attach(io: file, filename: "#{item.name.parameterize}.jpg")
    end
  end
end

puts "Seeding completed successfully!"