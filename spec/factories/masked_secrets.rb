FactoryBot.define do
  factory :masked_secret do
    uuid { "MyString" }
    count { 1 }
    notes { "MyText" }
    secret { "MyString" }
    secret_hash { "MyString" }
    client { nil }
  end
end
