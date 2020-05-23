FactoryBot.define do
  factory :sex_type do
    sequence(:name) { |n| "sex type #{n}" }
  end

  factory :standard do
    sequence(:name) { |n| "standard #{n}" }
    trait_class
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
