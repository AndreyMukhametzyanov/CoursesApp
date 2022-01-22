# frozen_string_literal: true

class Lesson < ApplicationRecord
  belongs_to :course

  validates :content, presence: true
end
