# frozen_string_literal: true

# == Schema Information
#
# Table name: user_projects
#
#  id               :bigint           not null, primary key
#  complete         :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  final_project_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_user_projects_on_final_project_id  (final_project_id)
#  index_user_projects_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (final_project_id => final_projects.id)
#  fk_rails_...  (user_id => users.id)
#
class UserProject < ApplicationRecord
  belongs_to :final_project
  belongs_to :user
  has_many :replies, dependent: :destroy

  validates :user_id, uniqueness: { scope: :final_project_id }

  def time_remaining
    (created_at.beginning_of_day + final_project.execution_days.days) - Time.zone.now.beginning_of_day
  end

  def student_time_left
    (time_remaining / 60 / 60 / 24).to_i
  end

  def time_is_over?
    student_time_left <= 0
  end
end