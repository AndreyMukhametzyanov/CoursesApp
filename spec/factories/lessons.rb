# frozen_string_literal: true

FactoryBot.define do
  factory :lesson do
    course
    title { 'Lesson' }
    youtube_video_id { '' }
    content { 'MyText' }
    sequence(:order_factor) { |i| i + 1 }
  end
end
