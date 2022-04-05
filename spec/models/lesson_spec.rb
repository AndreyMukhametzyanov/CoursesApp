# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  subject { build(:lesson) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
  end
end
