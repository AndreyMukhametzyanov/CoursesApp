# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :user

  validates :description, :level, presence: true
  validates :name, presence: true, uniqueness: true
end
