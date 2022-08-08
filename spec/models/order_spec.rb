# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  progress   :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_orders_on_course_id              (course_id)
#  index_orders_on_course_id_and_user_id  (course_id,user_id) UNIQUE
#  index_orders_on_user_id                (user_id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { build(:order, progress: { total_lessons: 2,
                                      completed_lessons_ids: [1, 2],
                                      project_complete: false,
                                      exam_complete: false
  }) }

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:course_id).scoped_to(:user_id) }
  end

  describe 'complete lessons' do
    it 'include complete lesson id' do
      expect(subject.lesson_complete?(subject.progress['completed_lessons_ids'].first)).to be_truthy
    end
  end

  describe 'percentage count' do
    let(:percent) { subject.progress['completed_lessons_ids'].count * 100 / subject.total_lessons_count }

    it 'count percentage' do
      expect(subject.percentage_count).to eq(percent)
    end
  end

  describe 'total lessons count' do
    let(:check_exam) { subject.progress['exam_complete'].nil? ? 0 : 1 }
    let(:check_project) { subject.progress['exam_complete'].nil? ? 0 : 1 }
    let(:correct_number) { subject.progress['total_lessons'] + check_exam + check_project }

    context 'when course have only lessons' do
      let(:only_lessons) { build(:order, progress: { total_lessons: 2,
                                                     completed_lessons_ids: [1, 2],
                                                     project_complete: nil,
                                                     exam_complete: nil
      }) }

      it 'return correct number of lessons of course' do
        expect(subject.total_lessons_count).to eq(correct_number)
      end
    end

    context 'when course have lessons end exam' do
      let(:lessons_and_exam) { build(:order, progress: { total_lessons: 2,
                                                         completed_lessons_ids: [1, 2],
                                                         project_complete: nil,
                                                         exam_complete: false
      }) }

      it 'return correct number of lessons of course' do
        expect(subject.total_lessons_count).to eq(correct_number)
      end
    end

    context 'when course have lessons, exam and project' do
      it 'return correct number of lessons of course' do
        expect(subject.total_lessons_count).to eq(correct_number)
      end
    end

  end

end
