# db/seeds.rb
require "open-uri"

# Clear existing data
Review.destroy_all
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all

puts "Seeding categories and products with multiple images..."

categories_data = [
  {
    name: "Wall Art",
    slug: "wall-art",
    description: "Beautiful wall paintings and frames",
    items: [
      {
        name: "Abstract Canvas Painting",
        description: "Modern abstract splash painting for living rooms. This stunning piece features bold colors and dynamic brushstrokes that will become the focal point of any room.",
        price: 129.99,
        compare_at_price: 159.99,
        quantity: 15,
        material: "Canvas, Acrylic",
        size: "24\" x 36\"",
        style: "Abstract",
        features: {
          "Material" => "Premium stretched canvas",
          "Frame" => "Gallery-wrapped edges",
          "Finish" => "Glossy protective coating",
          "Hardware" => "Sawtooth hanger included"
        },
        image_ids: [
          "1541961017774-22349e4a1262",
          "1579783902614-a3fb3927b6a5",
          "1531913764164-f85c52e6e654",
          "1515405295579-ba7b45403062"
        ]
      },
      {
        name: "Minimalist Line Art Frame",
        description: "Elegant black and white line art decor. Simple yet sophisticated, this piece adds a touch of modern elegance to any space.",
        price: 59.99,
        compare_at_price: 79.99,
        quantity: 8,
        material: "Paper, Wood Frame",
        size: "18\" x 24\"",
        style: "Minimalist",
        features: {
          "Material" => "Acid-free archival paper",
          "Frame" => "Solid wood with matte finish",
          "Glass" => "UV-protective acrylic",
          "Orientation" => "Vertical or horizontal"
        },
        image_ids: [
          "1513519245088-0e12902e5a38",
          "1616047006789-b7af5afb8dc0",
          "1579783901586-d88db74b4fe4",
          "1500462918385-b6f6e3a559b7"
        ]
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
        description: "Luxury hanging pendant light with a stunning golden finish. Perfect for dining rooms or entryways, this lamp creates a warm, inviting ambiance.",
        price: 199.99,
        compare_at_price: 249.99,
        quantity: 5,
        material: "Brass, Glass",
        size: "15\" diameter x 20\" height",
        style: "Modern Luxury",
        features: {
          "Material" => "Solid brass with gold finish",
          "Shade" => "Hand-blown opal glass",
          "Bulb" => "Compatible with LED (not included)",
          "Installation" => "Hardwired, adjustable cord"
        },
        image_ids: [
          "1519710164239-da123dc03ef4",
          "1543198126-c78d0bfb2b4a",
          "1585129767188-24a13d8bff56",
          "1565814636199-ae3e304e2ee2"
        ]
      },
      {
        name: "Modern Table Lamp",
        description: "Stylish bedside lamp with adjustable brightness. Combines form and function for your reading nook or nightstand.",
        price: 89.99,
        compare_at_price: nil,
        quantity: 3,
        material: "Ceramic, Linen",
        size: "12\" width x 22\" height",
        style: "Contemporary",
        features: {
          "Material" => "Glazed ceramic base",
          "Shade" => "Linen fabric drum shade",
          "Switch" => "3-way rotary switch",
          "Bulb" => "Accepts up to 100W (not included)"
        },
        image_ids: [
          "1507473885765-e6ed057f782c",
          "1540932239986-30128078f3c5",
          "1507309653280-19c72e330a01",
          "1585776245991-cf89dd7fc73a"
        ]
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
        description: "Handcrafted ceramic vase with unique splash texture. Each piece is individually made, making it truly one-of-a-kind.",
        price: 49.99,
        compare_at_price: 69.99,
        quantity: 0,
        material: "Ceramic",
        size: "8\" diameter x 10\" height",
        style: "Artisanal",
        features: {
          "Material" => "High-fire ceramic",
          "Finish" => "Glossy reactive glaze",
          "Usage" => "Fresh or dried flowers",
          "Care" => "Wipe clean with soft cloth"
        },
        image_ids: [
          "1501004318641-b39e6451bec6",
          "1578500494198-246f612d3b3d",
          "1612196808214-b7e239e5dd0c",
          "1581783898377-1c85bf937427"
        ]
      },
      {
        name: "Artificial Indoor Plant",
        description: "Realistic decorative indoor plant that never needs watering. Bring life to your space without the maintenance.",
        price: 39.99,
        compare_at_price: nil,
        quantity: 12,
        material: "Silk, Plastic",
        size: "12\" width x 24\" height",
        style: "Tropical",
        features: {
          "Material" => "Premium silk leaves",
          "Pot" => "Nursery pot included",
          "Maintenance" => "Dust occasionally",
          "UV" => "Fade-resistant"
        },
        image_ids: [
          "1492724441997-5dc865305da7",
          "1485955900006-10f4d324d411",
          "1593482892290-f54927ae2bb6",
          "1545165375-3226e64e9e3a"
        ]
      }
    ]
  }
]

def attach_multiple_images(product, image_ids)
  image_ids.each_with_index do |id, index|
    begin
      url = "https://images.unsplash.com/photo-#{id}?w=800&q=80&auto=format"
      file = URI.open(url)
      
      filename = "#{product.name.parameterize}-#{index + 1}.jpg"
      product.images.attach(io: file, filename: filename)
      
      puts "  ✓ Attached image #{index + 1} for #{product.name}"
    rescue => e
      puts "  ⚠ Failed to attach image #{index + 1} for #{product.name}: #{e.message}"
    end
    
    sleep(0.2)
  end
  
  # Fallback if no images attached
  if product.images.count == 0
    begin
      fallback_url = "https://picsum.photos/800/600?random=#{product.id}"
      file = URI.open(fallback_url)
      product.images.attach(io: file, filename: "#{product.name.parameterize}-fallback.jpg")
      puts "  ✓ Attached fallback image for #{product.name}"
    rescue => e
      puts "  ✗ Critical: Could not attach even fallback image: #{e.message}"
    end
  end
end

categories_data.each do |category_data|
  items = category_data.delete(:items)
  
  puts "\nCreating category: #{category_data[:name]}"
  
  category = Category.find_or_create_by!(slug: category_data[:slug]) do |c|
    c.name = category_data[:name]
    c.description = category_data[:description]
  end
  
  items.each do |item_data|
    puts "  Creating product: #{item_data[:name]}"
    
    # Extract image_ids before creating product
    image_ids = item_data.delete(:image_ids)
    
    # Create the product with all new attributes
    product = category.products.find_or_create_by!(name: item_data[:name]) do |item|
      item.description = item_data[:description]
      item.price = item_data[:price]
      item.compare_at_price = item_data[:compare_at_price]
      item.quantity = item_data[:quantity]
      item.material = item_data[:material]
      item.size = item_data[:size]
      item.style = item_data[:style]
      item.features = item_data[:features]
    end
    
    # Attach multiple images
    if product.images.attached? && product.images.count >= 2
      puts "    Product already has #{product.images.count} images, skipping"
    else
      attach_multiple_images(product, image_ids)
    end
  end
end

# Create sample reviews
puts "\nCreating sample reviews..."

review_comments = [
  "Absolutely love this! Looks even better in person.",
  "Great quality and fast shipping. Highly recommend!",
  "Perfect addition to my home decor. Very satisfied.",
  "Good value for money. Would buy again.",
  "Beautiful piece! Exactly as described.",
  "Excellent craftsmanship. Very happy with my purchase.",
  "Looks amazing on my wall. Received many compliments!",
  "The quality exceeded my expectations. Will order again."
]

Product.all.each do |product|
  next if product.reviews.count > 0
  
  rand(2..4).times do
    begin
      product.reviews.create!(
        rating: rand(3..5),
        comment: review_comments.sample,
        user_id: nil
      )
    rescue => e
      puts "  ⚠ Could not create review: #{e.message}"
    end
  end
  puts "  ✓ Created #{product.reviews.count} reviews for #{product.name}"
end

puts "\n✅ Seeding completed successfully!"
puts "📊 Summary:"
puts "  • #{Category.count} categories"
puts "  • #{Product.count} products"
puts "  • #{Product.where('quantity > 0').count} products in stock"
puts "  • #{Product.on_sale.count} products on sale"
puts "  • #{Review.count} reviews"

# Display products with their details
puts "\n📦 Product Details:"
Product.all.each do |product|
  puts "\n  #{product.name}:"
  puts "    Price: $#{product.price}" + (product.on_sale? ? " (was $#{product.compare_at_price}, #{product.discount_percentage}% off)" : "")
  puts "    Stock: #{product.quantity} units - #{product.stock_status}"
  puts "    Material: #{product.material}" if product.material.present?
  puts "    Size: #{product.size}" if product.size.present?
  puts "    Style: #{product.style}" if product.style.present?
  puts "    Images: #{product.images.count} attached"
  puts "    Features: #{product.features.keys.count if product.features.present?}"
end