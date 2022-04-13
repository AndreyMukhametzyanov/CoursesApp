# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user
    course
  end
end
