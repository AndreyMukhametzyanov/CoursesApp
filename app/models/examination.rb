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
end
