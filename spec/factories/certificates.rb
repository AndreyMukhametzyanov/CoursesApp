# frozen_string_literal: true

# == Schema Information
#
# Table name: certificates
#
#  id         :bigint           not null, primary key
#  uniq_code  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#
# Indexes
#
#  index_certificates_on_order_id  (order_id)
#
FactoryBot.define do
  factory :certificate do
    uniq_code { SecureRandom.alphanumeric(30) }
  end
end
