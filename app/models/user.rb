# frozen_string_literal: true

class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :ordered_courses, class_name: 'Course', through: :orders, dependent: :destroy, foreign_key: 'course_id'
  has_many :developed_courses, class_name: 'Course', dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
