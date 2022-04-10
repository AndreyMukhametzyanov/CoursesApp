# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { build(:order) }

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:course_id).scoped_to(:user_id) }
  end
end
