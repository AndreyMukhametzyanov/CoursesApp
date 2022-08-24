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
  has_many :certificates, dependent: :destroy

  store_accessor :progress, :total_lessons
  store_accessor :progress, :project_complete
  store_accessor :progress, :exam_complete
  store_accessor :progress, :completed_lessons_ids

  validates :course_id, uniqueness: { scope: :user_id }

  before_create :build_progress_hash

  def lesson_complete?(lesson_id)
    completed_lessons_ids.include?(lesson_id)
  end

  def percentage_count
    exam = exam_complete ? 1 : 0
    final_project = project_complete ? 1 : 0
    (completed_lessons_ids.count + exam + final_project) * 100 / total_course_parts
  end

  def total_course_parts
    total = total_lessons
    total += 1 unless exam_complete.nil?
    total += 1 unless project_complete.nil?
    total
  end

  def exam_complete!
    self.exam_complete = true
    save
  end

  def complete_lesson!(lesson_id)
    completed_lessons_ids << lesson_id.to_i
    save
  end

  def project_complete!
    self.project_complete = true
    save
  end

  def build_progress_hash
    if course.present?
      self.progress = { total_lessons: course.lessons.count, completed_lessons_ids: [] }

      progress.tap do |h|
        h[:project_complete] = false if course.final_project.present?
        h[:exam_complete] = false if course.exam.present?
      end
    else
      self.progress = {}
    end
  end
end
