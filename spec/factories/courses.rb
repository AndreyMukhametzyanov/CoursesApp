# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    sequence(:name) { |i| "Name#{i}" }
    description { 'MyString' }
    level { 1 }
  end
end
