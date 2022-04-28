# frozen_string_literal: true

FactoryBot.define do
  factory :exam do
    course
    title { 'MyString' }
    description { 'MyString' }
    attempts_number { 1 }
    attempts_time { 120 }
  end
end
