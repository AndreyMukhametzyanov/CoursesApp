# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    author { create :user }
    sequence(:name) { |i| "Name#{i}" }
    video_link { '' }
    description { 'MyString' }
    level { 1 }
    cover_picture { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png')) }
  end
end
