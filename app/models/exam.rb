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
class Exam < ApplicationRecord
  belongs_to :course
  has_many :questions, dependent: :destroy

  validates :title, :description, presence: true
  validates :attempts_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_blank: true
  validates :attempt_time, numericality: { only_integer: true, greater_than_or_equal_to: 60 }, allow_blank: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  def passed_by_user?(user)
    Examination.where(user: user, exam: self, finished_exam: true).any?
  end
end
