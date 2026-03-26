FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "Password123" }
    password_confirmation { password }
    role { :runner }
    token_version { 0 }
  end
end
