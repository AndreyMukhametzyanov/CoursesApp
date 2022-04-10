# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user_id { 1 }
    course_id { 1 }
  end
end
