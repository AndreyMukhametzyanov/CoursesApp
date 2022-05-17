# frozen_string_literal: true

class Exam < ApplicationRecord
  belongs_to :course
  has_many :questions, dependent: :destroy

  validates :title, :description, presence: true
  validates :attempts_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_blank: true
  validates :attempt_time, numericality: { only_integer: true, greater_than_or_equal_to: 60 }, allow_blank: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  def passed?(user)
    Examination.where(user: user, exam: self, finished_exam: true).any?
  end
end
