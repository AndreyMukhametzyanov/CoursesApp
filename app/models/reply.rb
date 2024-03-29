# frozen_string_literal: true

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
class Reply < ApplicationRecord
  include AASM

  belongs_to :user_project
  has_one :user, through: :user_project
  has_many_attached :files

  validates :user_reply, presence: true, if: -> { files.empty? }
  validates :status, presence: true

  aasm column: :status do
    state :verification, initial: true, display: I18n.t('reply.status.verification')
    state :rejected, display: I18n.t('reply.status.rejected')
    state :accepted, display: I18n.t('reply.status.accepted')

    event :accept do
      transitions from: :verification, to: :accepted
    end

    event :reject do
      transitions from: :verification, to: :rejected
    end
  end

  def available_statuses_for_select
    aasm.states(permitted: true).map { |s| [s.display_name, s.name] }
  end
end
