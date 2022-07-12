# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id                :bigint           not null, primary key
#  description       :string
#  level             :integer
#  name              :string
#  short_description :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null
#  youtube_video_id  :text
#
# Indexes
#
#  index_courses_on_name     (name) UNIQUE
#  index_courses_on_user_id  (user_id)
#
class Course < ApplicationRecord
  CORRECT_URL_PART = 'https://www.youtube.com/watch?v'

  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :developed_courses
  has_one :exam, dependent: :destroy
  has_one :final_project, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :students, class_name: 'User', through: :orders, source: 'user'
  has_one_attached :cover_picture
  has_rich_text :description

  attr_accessor :video_link

  validate :check_url
  validates :description, :short_description, :level, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: 6 }
  validates :name, presence: true, uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }
  validate :correct_picture_type, if: :cover_picture

  before_save :take_video_id

  def owner?(user)
    author == user
  end

  def enrolled_in_course?(user)
    students.find_by(id: user.id).present?
  end

  def parts_count
    if lessons.any?
      parts = lessons.count
      if final_project.present? && exam.present?
        parts + 2
      elsif final_project.present? || exam.present?
        parts + 1
      end
    else
      flash[:alert] = I18n.t('errors.lessons.lesson_not_create')
      redirect_to root_path
    end
  end

  private

  def take_video_id
    self.youtube_video_id = video_link.split('=').last if video_link
  end

  def check_url
    return if video_link.blank?

    correct_link, id = video_link.split('=')
    correct_link == CORRECT_URL_PART ? id : errors.add(:video_link, :is_not_youtube_link)
  end

  def correct_picture_type
    return unless cover_picture.attached?

    errors.add(:cover_picture, :is_not_picture_type) unless cover_picture.content_type.in?(IMAGE_TYPE)
  end
end

