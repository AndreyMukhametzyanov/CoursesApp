# frozen_string_literal: true

# == Schema Information
#
# Table name: votes
#
#  id         :bigint           not null, primary key
#  kind       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lesson_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_votes_on_lesson_id              (lesson_id)
#  index_votes_on_user_id                (user_id)
#  index_votes_on_user_id_and_lesson_id  (user_id,lesson_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (lesson_id => lessons.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :vote do
    user
    lesson
  end
end
