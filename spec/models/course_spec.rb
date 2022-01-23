# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  subject { build(:course) }
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:level) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_numericality_of(:level).is_greater_than_or_equal_to(1).is_less_than(6) }
  end
  describe 'associations' do
    it { should belong_to(:user) }
  end
end
