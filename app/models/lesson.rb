# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :bigint           not null, primary key
#  content          :text
#  order_factor     :integer
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  course_id        :bigint           not null
#  youtube_video_id :text
#
# Indexes
#
#  index_lessons_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
class Lesson < ApplicationRecord
  include Commentable

  belongs_to :course
  has_many :links, dependent: :destroy
  has_many_attached :files
  has_rich_text :content

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :content, presence: true
  validates :order_factor, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  scope :order_by_factor, -> { order(:order_factor) }

  def owner?(user)
    course.author == user
  end
end
