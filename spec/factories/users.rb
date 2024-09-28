# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    # Generate a unique email for each user
    sequence(:email) { |n| "user#{n}@example.com" }

    # Set a default password for the user
    password { 'password123' }
    password_confirmation { 'password123' }

    # Optionally, you can set values for other fields as needed, though Devise handles most of this
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }

    # If you need specific traits, you can define them:
    trait :with_reset_password_token do
      reset_password_token { SecureRandom.hex(10) }
      reset_password_sent_at { Time.current }
    end
  end
end
