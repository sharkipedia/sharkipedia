FactoryBot.define do
  factory :trait do
    sequence(:name) { |n| "trait #{n}" }
    trait_class
  end
end

FactoryBot.define do
  factory :trait_class do
    sequence(:name) { |n| "trait_class #{n}" }
  end
end
