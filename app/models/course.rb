# frozen_string_literal: true

class Course < ApplicationRecord
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :developed_courses
  has_many :lessons, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :students, class_name: 'User', through: :orders, source: 'user'
  has_one_attached :cover_picture

  attr_accessor :video_link

  before_save :take_video_id

  validate :check_url
  validates :description, :level, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: 6 }
  validates :name, presence: true, uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }
  validate :correct_picture_type, if: :cover_picture

  def owner?(user)
    author == user
  end

  def enrolled_in_course?(user)
    students.find_by(id: user.id).present?
  end

  private

  def take_video_id
    self.youtube_video_id = video_link.split('=').last if video_link
  end

  def check_url
    correct = 'https://www.youtube.com/watch?v'
    return if video_link.blank?

    correct_link, id = video_link.split('=')
    correct_link == correct ? id : errors.add(:video_link, :is_not_youtube_link)
  end

  def correct_picture_type
    image_types = %w[image/gif image/jpeg image/pjpeg image/png image/svg+xml
                     image/tiff image/vnd.microsoft.icon image/vnd.wap.wbmp image/webp]
    return unless cover_picture.attached?

    errors.add(:cover_picture, :is_not_picture_type) unless cover_picture.content_type.in?(image_types)
  end
end
