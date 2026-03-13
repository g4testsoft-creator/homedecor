FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    price { Faker::Commerce.price(range: 10.00..500.00) }
    category { association :category }

    trait :with_image do
      after(:build) do |product|
        product.images.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/test_image.jpg')),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end

    trait :without_category do
      category { nil }
    end
  end
end
