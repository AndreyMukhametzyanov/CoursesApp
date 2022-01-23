# frozen_string_literal: true

class User < ApplicationRecord
  has_many :courses

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
