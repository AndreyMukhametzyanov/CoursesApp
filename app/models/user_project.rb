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
#  index_user_project_final_project_id_and_user_id  (final_project_id,user_id) UNIQUE
#  index_user_projects_on_final_project_id          (final_project_id)
#  index_user_projects_on_user_id                   (user_id)
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

  validates :user_id , uniqueness: { scope: :final_project_id }
end
