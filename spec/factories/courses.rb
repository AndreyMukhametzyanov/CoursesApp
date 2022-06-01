# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id               :bigint           not null, primary key
#  description      :string
#  level            :integer
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#  youtube_video_id :text
#
# Indexes
#
#  index_courses_on_name     (name) UNIQUE
#  index_courses_on_user_id  (user_id)
#
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
