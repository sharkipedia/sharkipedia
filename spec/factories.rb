FactoryBot.define do
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
end
