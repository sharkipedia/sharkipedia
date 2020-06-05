FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    user_level { "user" }
    password { "123456789!password" }
    confirmed_at { Time.now.utc }

    factory :editor do
      sequence(:name) { |n| "editor #{n}" }
      sequence(:email) { |n| "editor#{n}@example.com" }
      user_level { "editor" }
    end

    factory :contributor do
      sequence(:name) { |n| "contributor #{n}" }
      sequence(:email) { |n| "contributor#{n}@example.com" }
      user_level { "contributor" }
    end

    factory :admin do
      sequence(:name) { |n| "admin #{n}" }
      sequence(:email) { |n| "admin#{n}@example.com" }
      user_level { "admin" }
    end
  end

  factory :reference do
    sequence(:name) { |n| "reference #{n}" }
  end

  factory :sex_type do
    sequence(:name) { |n| "sex type #{n}" }
  end

  factory :standard do
    sequence(:name) { |n| "standard #{n}" }
    trait_class
  end

  factory :unit_time do
    sequence(:name) { |n| "unit_time #{n}" }
  end

  factory :unit_spatial do
    sequence(:name) { |n| "unit_spatial #{n}" }
  end

  factory :sampling_method do
    sequence(:name) { |n| "sampling_method #{n}" }
  end

  factory :data_type do
    sequence(:name) { |n| "data_type #{n}" }
  end

  factory :ocean do
    sequence(:name) { |n| "ocean #{n}" }
  end

  factory :import do
    sequence(:title) { |n| "import #{n}" }
    aasm_state { "pending_review" }
    xlsx_valid { true }
    log { "" }
    user

    factory :traits_import do
      sequence(:title) { |n| "traits import #{n}" }
      import_type { "traits" }
      xlsx_file { Rack::Test::UploadedFile.new("spec/fixtures/xlsx/traits_valid.xlsx") }
    end

    factory :trends_import do
      sequence(:title) { |n| "traits import #{n}" }
      import_type { "traits" }
      xlsx_file { Rack::Test::UploadedFile.new("spec/fixtures/xlsx/trends_valid.xlsx") }
    end
  end

  factory :trait do
    sequence(:name) { |n| "trait #{n}" }
    trait_class
  end

  factory :trait_class do
    sequence(:name) { |n| "trait_class #{n}" }
  end

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

  factory :species_group do
    sequence(:name) { |n| "species group #{n}" }

    factory :species_group_with_species do
      transient do
        species_count { 5 }
      end

      after(:create) do |species_group, evaluator|
        create_list(:species, evaluator.species_count, species_groups: [species_group])
      end
    end
  end

  factory :measurement_model do
    sequence(:name) { |n| "measurement_model #{n}" }
    trait_class
  end

  factory :measurement_method do
    sequence(:name) { |n| "measurement_method #{n}" }
    trait_class
  end

  factory :longhurst_province do
    sequence(:name) { |n| "longhurst_province #{n}" }
    sequence(:code) { |n| "code #{n}" }
  end

  factory :value_type do
    sequence(:name) { |n| "value_type #{n}" }
  end

  factory :precision_type do
    sequence(:name) { |n| "precision_type #{n}" }
  end

  factory :location do
    sequence(:name) { |n| "location #{n}" }
    sequence(:lat) { |n| n }
    sequence(:lon) { |n| n }
  end

  factory :trend do
    user
    import
    reference
    species
    location
    ocean
    data_type
    standard
    sampling_method

    start_year { 1900 }
    end_year { 2020 }

    factory :trend_with_species_group do
      species { nil }
      species_group
    end
  end

  factory :trend_observation do
    sequence(:year) { |n| 1900 + n }
    value { rand(1..200) }
  end

  factory :source_observation do
    sequence(:name) { |n| "source_observation #{n}" }
  end
end
