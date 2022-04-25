class Question < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :answers, allow_destroy: true
end
