# frozen_string_literal: true

# == Schema Information
#
# Table name: feedbacks
#
#  id         :bigint           not null, primary key
#  body       :text
#  grade      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_feedback_on_course_id_and_user_id  (user_id,course_id) UNIQUE
#  index_feedbacks_on_course_id             (course_id)
#  index_feedbacks_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (user_id => users.id)
#
class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :body, length: { minimum: 10 }, allow_blank: true
  validates :grade, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: 6 }
  validates :course_id, uniqueness: { scope: :user_id }
end
