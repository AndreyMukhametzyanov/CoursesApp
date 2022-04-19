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
    it { is_expected.to have_many_attached(:files) }
  end

  describe 'owned by user' do
    let!(:course) { create :course }
    let!(:lesson) { create :lesson, course: course }

    it 'is owner' do
      expect(lesson).to be_owner(course.author)
    end
  end
end
