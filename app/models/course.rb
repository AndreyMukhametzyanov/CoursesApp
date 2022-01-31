# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :user
  has_many :lessons

  attr_accessor :video_link

  before_save :take_video_id

  validate :check_url
  validates :description, :level, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: 6 }
  validates :name, presence: true, uniqueness: true
  validates :name, uniqueness: { case_sensitive: false }

  private

  def take_video_id
    self[:youtube_video_id] = video_link.split('=').last
  end

  def check_url
    correct_url = 'https://www.youtube.com/watch?v'
    errors.add(:video_link, 'this link is not from YouTube hosting') if video_link.split('=').first != correct_url
  end
end
