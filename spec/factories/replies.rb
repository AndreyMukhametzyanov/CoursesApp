# == Schema Information
#
# Table name: replies
#
#  id              :bigint           not null, primary key
#  status          :text
#  teacher_comment :text
#  user_reply      :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_project_id :bigint           not null
#
# Indexes
#
#  index_replies_on_user_project_id  (user_project_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_project_id => user_projects.id)
#
FactoryBot.define do
  factory :reply do
    user_project
    user_reply { "MyText" }
    teacher_comment { "MyText" }
    status { 1 }
  end
end
