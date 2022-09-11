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
require 'rails_helper'

RSpec.describe Certificate, type: :model do
  subject { build(:certificate) }

  describe 'associations' do
    it { is_expected.to belong_to(:order) }
  end
end
