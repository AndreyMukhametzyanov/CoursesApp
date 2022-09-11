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
class Certificate < ApplicationRecord
  has_one_attached :pdf
  belongs_to :order
end
