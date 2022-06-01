# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id         :bigint           not null, primary key
#  address    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lesson_id  :bigint
#
# Indexes
#
#  index_links_on_lesson_id  (lesson_id)
#
class Link < ApplicationRecord
  belongs_to :lesson

  validates :address, presence: true
  validate :correct_url, if: :address

  private

  def correct_url
    errors.add(:address, :is_not_uri) unless URI.parse(address).is_a?(URI::HTTP)
  end
end
