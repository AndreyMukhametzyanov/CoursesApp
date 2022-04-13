# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :course_id, uniqueness: { scope: :user_id }
end
