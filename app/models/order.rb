# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  progress   :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_orders_on_course_id              (course_id)
#  index_orders_on_course_id_and_user_id  (course_id,user_id) UNIQUE
#  index_orders_on_user_id                (user_id)
#
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :course

  store_accessor :progress, :total_lessons
  store_accessor :progress, :project_complete
  store_accessor :progress, :exam_complete
  store_accessor :progress, :completed_lessons_ids

  validates :course_id, uniqueness: { scope: :user_id }

  def lesson_complete?(lesson_id)
    completed_lessons_ids.include?(lesson_id)
  end

  def percentage_count
    completed_lessons_ids.count * 100 / total_lessons_count
  end

  def total_lessons_count
    total = total_lessons
    total += 1 unless exam_complete.nil?
    total += 1 unless project_complete.nil?
    total
  end
end
