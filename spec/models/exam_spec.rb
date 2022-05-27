# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exam, type: :model do
  subject { build(:exam) }

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to have_many(:questions) }
    it { is_expected.to accept_nested_attributes_for :questions }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_numericality_of(:attempts_count).is_greater_than_or_equal_to(1) }
    it { is_expected.to allow_value('', nil).for(:attempts_count) }
    it { is_expected.to validate_numericality_of(:attempt_time).is_greater_than_or_equal_to(60) }
    it { is_expected.to allow_value('', nil).for(:attempt_time) }
  end
end
