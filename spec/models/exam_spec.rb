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

  describe 'passed by user' do
    let!(:user) { create(:user) }
    let!(:course) { create(:course, students: [user]) }
    let!(:exam) { create(:exam, course: course) }

    it 'return false' do
      expect(exam.passed_by_user?(user)).to be_falsey
    end
  end
end
