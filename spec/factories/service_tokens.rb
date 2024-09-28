FactoryBot.define do
  factory :service_token do
    token { "MyString" }
    user { nil }
    permission { "MyString" }
    expires_at { "2024-09-18 19:13:08" }
  end
end
