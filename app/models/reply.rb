# == Schema Information
#
# Table name: replies
#
#  id              :bigint           not null, primary key
#  status          :integer
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
class Reply < ApplicationRecord
  belongs_to :user_project
  enum status: { verification: 0, rejected: 1, accepted: 2 }

  validates :user_reply, presence: true
end
