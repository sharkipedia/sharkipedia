FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    user_level { 'user' }
    password { "123456789!password" }
  end

  factory :editor, parent: :user do
    email { "editor@example.com" }
    user_level { 'editor' }
  end

  factory :contributor, parent: :user do
    email { "contributor@example.com" }
    user_level { 'contributor' }
  end

  factory :admin, parent: :user do
    email { "admin@example.com" }
    user_level { 'admin' }
  end
end

