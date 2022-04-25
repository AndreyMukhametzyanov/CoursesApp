FactoryBot.define do
  factory :exam do
    title { "MyString" }
    description { "MyString" }
    attempts_number { 1 }
    attempts_time { 1 }
    course { nil }
  end
end
