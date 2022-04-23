# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    lesson
    address { 'https://github.com/AndreyMukhametzyanov' }
  end
end
