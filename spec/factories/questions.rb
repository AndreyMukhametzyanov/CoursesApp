# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint           not null
#
# Indexes
#
#  index_questions_on_exam_id  (exam_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#
FactoryBot.define do
  factory :question do
    sequence(:title) { |i| "Question #{i}" }
    answers do
      [
        build(:answer, :true_answer),
        build(:answer)
      ]
    end

    trait :without_answers do
      answers { [] }
    end
  end
end
