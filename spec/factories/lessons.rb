# frozen_string_literal: true

FactoryBot.define do
  factory :lesson do
    youtube_video_id { '' }
    content { 'MyText' }
  end
end
