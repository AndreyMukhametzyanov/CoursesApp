# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id             :bigint           not null, primary key
#  body           :string
#  correct_answer :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  question_id    :bigint           not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
FactoryBot.define do
  factory :answer do
    question
    sequence(:body) { |i| "Answer #{i}" }

    trait :true_answer do
      correct_answer { true }
    end
  end
end
