# frozen_string_literal: true

FactoryBot.define do
  factory :lesson do
    course
    youtube_video_id { '' }
    content { 'MyText' }
  end
end
