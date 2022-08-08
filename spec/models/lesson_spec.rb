# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :bigint           not null, primary key
#  content          :text
#  order_factor     :integer
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  course_id        :bigint           not null
#  youtube_video_id :text
#
# Indexes
#
#  index_lessons_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
require 'rails_helper'

RSpec.describe Lesson, type: :model do
  subject { build(:lesson) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_numericality_of(:order_factor).is_greater_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    # it { is_expected.to have_many_attached(:files) }
    # it { is_expected.to have_many(:links) }
    # it { is_expected.to accept_nested_attributes_for :links }
  end

  describe 'owned by user' do
    let!(:course) { create :course }
    let!(:lesson) { create :lesson, course: course }

    it 'is owner' do
      expect(lesson).to be_owner(course.author)
    end
  end

  describe 'unique order factor for course' do
    let!(:course) { create :course }
    let!(:lesson) { create :lesson, course: course }
    let!(:new_lesson) { build :lesson, course: course, order_factor: lesson.order_factor }
    let(:error_message) { I18n.t('activerecord.errors.models.lesson.attributes.order_factor.is_not_uniq_type') }

    before { new_lesson.save }

    it 'not unique' do
      expect(new_lesson.errors.messages[:order_factor].to_sentence).to eq(error_message)
    end
  end
end
