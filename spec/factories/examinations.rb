FactoryBot.define do
  factory :examination do
    passage_time { 1 }
    pass_exam { false }
    correct_answers { 1 }
    percentage_passing { 1 }
  end
end
