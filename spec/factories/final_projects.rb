# == Schema Information
#
# Table name: final_projects
#
#  id                :bigint           not null, primary key
#  description       :text
#  execution_days    :integer
#  short_description :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course_id         :bigint           not null
#
# Indexes
#
#  index_final_projects_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
FactoryBot.define do
  factory :final_project do
    description { "MyString" }
    text { "MyString" }
    short_description { "MyString" }
    text { "MyString" }
    execution_days { 1 }
    course { nil }
  end
end
