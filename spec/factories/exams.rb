# frozen_string_literal: true

FactoryBot.define do
  factory :exam do
    course
    title { 'MyString' }
    description { 'MyString' }
    attempts_count { 1 }
    attempt_time { 120 }
  end
end
