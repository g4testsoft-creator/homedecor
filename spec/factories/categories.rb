FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    slug { name.parameterize }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
