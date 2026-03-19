# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://homedecor.isrv.dev/"

SitemapGenerator::Sitemap.create do
  # Root path
  add root_path, priority: 1.0, changefreq: 'daily'

  # Static pages
  add products_path, priority: 0.9, changefreq: 'daily'

  # Add all categories
  Category.find_each do |category|
    add category_path(category), 
        priority: 0.8, 
        changefreq: 'weekly',
        lastmod: category.updated_at
  end

  # Add all products
  Product.find_each do |product|
    add product_path(product), 
        priority: 0.7, 
        changefreq: 'weekly',
        lastmod: product.updated_at
  end
end
