# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint           not null
#
# Indexes
#
#  index_questions_on_exam_id  (exam_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#
class Question < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :answers, allow_destroy: true
end
