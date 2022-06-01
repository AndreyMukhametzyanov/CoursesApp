# frozen_string_literal: true

# == Schema Information
#
# Table name: examinations
#
#  id                  :bigint           not null, primary key
#  correct_answers     :integer          default(0)
#  finished_exam       :boolean          default(FALSE)
#  number_of_questions :integer          default(0)
#  passage_time        :integer          default(0)
#  passed_exam         :boolean          default(FALSE)
#  percentage_passing  :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  current_question_id :bigint
#  exam_id             :bigint           not null
#  next_question_id    :bigint
#  user_id             :bigint           not null
#
# Indexes
#
#  index_examinations_on_current_question_id  (current_question_id)
#  index_examinations_on_exam_id              (exam_id)
#  index_examinations_on_next_question_id     (next_question_id)
#  index_examinations_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (current_question_id => questions.id)
#  fk_rails_...  (exam_id => exams.id)
#  fk_rails_...  (next_question_id => questions.id)
#  fk_rails_...  (user_id => users.id)
#
class Examination < ApplicationRecord
  belongs_to :exam
  belongs_to :user
  belongs_to :current_question, class_name: 'Question'
  belongs_to :next_question, class_name: 'Question', optional: true

  def self.create_default(user:, exam:, current_question:, next_question:)
    create(user: user, exam: exam, current_question: current_question, next_question: next_question, passage_time: 0,
           number_of_questions: 0, correct_answers: 0, percentage_passing: 0,
           passed_exam: false, finished_exam: false)
  end

  def time_remaining
    (created_at + exam.attempt_time) - Time.zone.now
  end
end
