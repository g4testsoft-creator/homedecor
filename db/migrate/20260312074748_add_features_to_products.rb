class AddFeaturesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :features, :jsonb
  end
end
