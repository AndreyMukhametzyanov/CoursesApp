# frozen_string_literal: true

# == Schema Information
#
# Table name: final_projects
#
#  id                :bigint           not null, primary key
#  description       :text
#  execution_days    :integer
#  short_description :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course_id         :bigint           not null
#
# Indexes
#
#  index_final_projects_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
class FinalProject < ApplicationRecord
  belongs_to :course
  has_many :user_projects, dependent: :destroy
  has_many_attached :files
  has_rich_text :description

  validates :short_description, :description, presence: true
  validates :execution_days, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  delegate :owner?, to: :course

  after_create :update_course_project

  private

  def update_course_project
    return if new_record?

    course.orders.each do |order|
      order.project_complete = false
      order.save
    end
  end
end
