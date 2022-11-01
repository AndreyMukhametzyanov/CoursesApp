# frozen_string_literal: true

# == Schema Information
#
# Table name: exams
#
#  id             :bigint           not null, primary key
#  attempt_time   :integer
#  attempts_count :integer
#  description    :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  course_id      :bigint           not null
#
# Indexes
#
#  index_exams_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
#
#
#
FactoryBot.define do
  factory :exam do
    course
    title { 'MyString' }
    description { 'MyString' }
    attempts_count { 1 }
    attempt_time { 120 }
    questions { build_list(:question, 5) }

    trait :without_questions do
      questions { [] }
    end
  end
end
