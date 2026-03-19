class AddSlugToProducts < ActiveRecord::Migration[7.0]
  def up
    add_column :products, :slug, :string

    # Backfill existing rows
    say_with_time "Backfilling product slugs" do
      Product.reset_column_information
      Product.find_each do |product|
        base = product.name.to_s.parameterize
        base = "product-#{product.id}" if base.blank?

        slug = base
        i = 2
        while Product.where.not(id: product.id).exists?(slug: slug)
          slug = "#{base}-#{i}"
          i += 1
        end

        product.update_columns(slug: slug)
      end
    end

    change_column_null :products, :slug, false
    add_index :products, :slug, unique: true
  end

  def down
    remove_index :products, :slug
    remove_column :products, :slug
  end
end

