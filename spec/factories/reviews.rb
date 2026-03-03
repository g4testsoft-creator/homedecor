FactoryBot.define do
  factory :review do
    user { association :user }
    product { association :product }
    rating { Faker::Number.between(from: 1, to: 5) }
    content { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
