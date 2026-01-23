DecorItem.destroy_all

DecorItem.create!([
  {
    name: "Scandinavian Floor Lamp",
    description: "Minimalist wooden floor lamp with warm linen shade, perfect for cozy living rooms.",
    price: 129.99,
    image_url: "https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=800&q=80"
  },
  {
    name: "Textured Throw Pillow",
    description: "Neutral-toned cushion with subtle geometric pattern to add depth to your sofa or bed.",
    price: 29.50,
    image_url: "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?auto=format&fit=crop&w=800&q=80"
  },
  {
    name: "Ceramic Vase Set",
    description: "Set of three matte ceramic vases in soft earthy tones, ideal for dried flowers.",
    price: 54.00,
    image_url: "https://images.unsplash.com/photo-1523755231516-e43fd2e8dca5?auto=format&fit=crop&w=800&q=80"
  },
  {
    name: "Framed Wall Art",
    description: "Abstract line art print in a light oak frame, suits modern and Scandinavian interiors.",
    price: 89.00,
    image_url: "https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=800&q=80"
  },
  {
    name: "Woven Jute Rug",
    description: "Handwoven jute area rug that brings natural warmth and texture to any room.",
    price: 199.00,
    image_url: "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?auto=format&fit=crop&w=800&q=80"
  }
])

puts "Seeded #{DecorItem.count} decor items."

