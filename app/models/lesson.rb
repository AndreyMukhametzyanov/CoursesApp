# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :course

  validates :content, presence: true
  validates :order_factor, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  scope :order_by_factor, -> { order(:order_factor) }
end
