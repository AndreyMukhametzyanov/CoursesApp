# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question
    body { 'MyString' }
  end
end
