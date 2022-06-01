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
class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
end
