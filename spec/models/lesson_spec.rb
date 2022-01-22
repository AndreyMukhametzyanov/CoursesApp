# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  subject { build(:lesson) }
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end
  describe 'associations' do
    it { should belong_to(:course) }
  end
end
