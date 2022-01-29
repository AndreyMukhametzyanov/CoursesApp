# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :course

  validates :content, presence: true
  validates :order_factor, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  scope :order_factor, -> { order(order_factor: :ASC) }
end
