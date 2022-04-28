# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    exam
    title { 'MyString' }
  end
end
