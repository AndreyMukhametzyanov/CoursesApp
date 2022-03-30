# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    user
    sequence(:name) { |i| "Name#{i}" }
    video_link { '' }
    description { 'MyString' }
    level { 1 }
  end
end
