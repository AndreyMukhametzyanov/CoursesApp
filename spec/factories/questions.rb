# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    exam
    sequence(:title) { |i| "Question #{i}" }

    trait :with_answers do
      answers do
        [
          build(:answer, :true_answer),
          build(:answer)
        ]
      end
    end
  end
end
