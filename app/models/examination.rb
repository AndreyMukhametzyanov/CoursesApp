class Examination < ApplicationRecord
  belongs_to :exam
  belongs_to :user
  belongs_to :current_question, class_name: 'Question'
  belongs_to :next_question, class_name: 'Question', optional: true
end
