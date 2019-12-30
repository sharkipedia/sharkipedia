FactoryBot.define do
  factory :species_superorder do
    sequence(:name) { |n| "superorder #{n}" }
    species_subclass
  end

  factory :species_subclass do
    sequence(:name) { |n| "subclass #{n}" }
  end

  factory :species_data_type do
    sequence(:name) { |n| "data_type #{n}" }
  end

  factory :species_order do
    sequence(:name) { |n| "order #{n}" }
    species_superorder
    species_subclass
  end

  factory :species_family do
    sequence(:name) { |n| "family #{n}" }
    species_subclass
    species_superorder
    species_order
  end

  factory :species do
    sequence(:name) { |n| "species #{n}" }

    species_superorder
    species_subclass
    species_order
    species_family
    species_data_type
  end
end
