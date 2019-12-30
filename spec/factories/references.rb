FactoryBot.define do
  factory :reference do
    sequence(:name) { |n| "reference #{n}" }
  end
end
