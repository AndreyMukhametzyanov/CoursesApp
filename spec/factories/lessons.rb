# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :bigint           not null, primary key
#  complete         :boolean          default(FALSE)
#  content          :text
#  order_factor     :integer
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  course_id        :bigint           not null
#  youtube_video_id :text
#
# Indexes
#
#  index_lessons_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
FactoryBot.define do
  factory :lesson do
    course
    sequence(:title) { |i| "Lesson#{i}" }
    youtube_video_id { '' }
    content { 'MyText' }
    sequence(:order_factor) { |i| i + 1 }
  end
end
