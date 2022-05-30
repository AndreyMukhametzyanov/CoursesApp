# frozen_string_literal: true

FactoryBot.define do
  factory :examination do
    user
    exam
    current_question {create exam.questions.first }
    next_question {create exam.questions.second }
    passage_time { 0 }
    passed_exam { false }
    finished_exam { false }
    number_of_questions { 4 }
    correct_answers { 1 }
    percentage_passing { 25 }
  end
end
