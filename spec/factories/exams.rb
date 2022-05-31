# frozen_string_literal: true

FactoryBot.define do
  factory :exam do
    course
    title { 'MyString' }
    description { 'MyString' }
    attempts_count { 1 }
    attempt_time { 120 }

    trait :with_questions do
      questions { build_list :questions, 5, :with_answers }
    end
  end
end
