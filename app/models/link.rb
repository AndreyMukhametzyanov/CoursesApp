# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :lesson

  validates :address, presence: true
  validate :correct_url, if: :address

  private

  def correct_url
    errors.add(:address, :is_not_uri) unless URI.parse(address).is_a?(URI::HTTP)
  end
end
