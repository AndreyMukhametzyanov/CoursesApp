# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Ivan' }
    last_name { 'Ivanov' }
    date_of_birth { '01.01.2001' }
    sequence(:email) { |i| "test#{i}@test.com" }
    password { '11223344' }
    password_confirmation { '11223344' }
  end
end
