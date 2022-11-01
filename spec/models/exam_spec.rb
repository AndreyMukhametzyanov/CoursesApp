# frozen_string_literal: true

# == Schema Information
#
# Table name: exams
#
#  id             :bigint           not null, primary key
#  attempt_time   :integer
#  attempts_count :integer
#  description    :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  course_id      :bigint           not null
#
# Indexes
#
#  index_exams_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
require 'rails_helper'

RSpec.describe Exam do
  subject(:exam) { build(:exam) }

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

  describe 'passed by user' do
    let(:examination) { create(:examination, exam: exam) }

    before { create(:order, course: exam.course) }

    it 'return false' do
      expect(exam).not_to be_passed_by_user(exam.course.students.first)
    end
  end

  describe 'after create callback' do
    let(:order) { create(:order, course: exam.course) }

    it 'return correct lessons count in order' do
      expect(order.exam_complete).to be_falsey
    end
  end
end
