# frozen_string_literal: true

class Course < ApplicationRecord
  include Commentable

  belongs_to :user
  has_many :lessons, dependent: :destroy

  attr_accessor :video_link

  before_save :take_video_id

  validate :check_url
  validates :description, :level, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: 6 }
  validates :name, presence: true, uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }

  def owner?(user)
    self.user == user
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
end
