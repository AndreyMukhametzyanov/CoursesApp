# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question
    sequence(:body) { |i| "Answer #{i}" }

    trait :true_answer do
      correct_answer { true }
    end
  end
end
