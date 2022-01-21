# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :user

  validates :description, :level, presence: true
  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: 6 }
  validates :name, presence: true, uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }
end
