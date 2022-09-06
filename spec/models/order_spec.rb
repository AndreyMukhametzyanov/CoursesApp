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
  subject(:order) do
    build(:order, progress: { total_lessons: 2,
                              completed_lessons_ids: [1, 2] })
  end

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    before { create :lesson, course: order.course }
    it { is_expected.to validate_uniqueness_of(:course_id).scoped_to(:user_id) }
  end

  describe 'complete lessons' do
    it 'include complete lesson id' do
      expect(order).to be_lesson_complete(order.completed_lessons_ids.first)
    end
  end

  describe 'percentage count' do
    let(:percent) { 50 }
    let(:order) do
      build(:order, progress: { total_lessons: 2,
                                completed_lessons_ids: [1] })
    end

    context 'when only lessons' do
      it 'count percentage' do
        expect(order.percentage_count).to eq(percent)
      end
    end

    context 'when all parts of exam' do
      let(:order) do
        build(:order, progress: { total_lessons: 2,
                                  completed_lessons_ids: [1],
                                  project_complete: true,
                                  exam_complete: false })
      end

      it 'count percentage' do
        expect(order.percentage_count).to eq(percent)
      end
    end
  end

  describe 'total lessons count' do
    let(:check_exam) { order.exam_complete.nil? ? 0 : 1 }
    let(:check_project) { order.exam_complete.nil? ? 0 : 1 }
    let(:correct_number) { order.total_lessons + check_exam + check_project }

    context 'when course have only lessons' do
      let(:only_lessons) do
        build(:order, progress: { total_lessons: 2,
                                  completed_lessons_ids: [1, 2],
                                  project_complete: nil,
                                  exam_complete: nil })
      end

      it 'return correct number of lessons of course' do
        expect(order.total_course_parts).to eq(correct_number)
      end
    end

    context 'when course have lessons end exam' do
      let(:lessons_and_exam) do
        build(:order, progress: { total_lessons: 2,
                                  completed_lessons_ids: [1, 2],
                                  project_complete: nil,
                                  exam_complete: false })
      end

      it 'return correct number of lessons of course' do
        expect(order.total_course_parts).to eq(correct_number)
      end
    end

    context 'when course have lessons, exam and project' do
      it 'return correct number of lessons of course' do
        expect(order.total_course_parts).to eq(correct_number)
      end
    end
  end

  describe 'build progress hash' do
    let(:hash) do
      { 'completed_lessons_ids' => [], :exam_complete => false, :project_complete => false, 'total_lessons' => 1 }
    end

    context 'when course created' do
      let!(:course) { create(:course) }
      let!(:order) { build(:order, course: course) }

      before do
        create(:lesson, course: course)
        create(:exam, course: course)
        create(:final_project, course: course)
      end

      it 'return correct build hash' do
        expect(order.build_progress_hash).to eq(hash)
      end
    end

    context 'when course is not created' do
      let!(:order) { build(:order, course: nil) }

      it 'return correct build hash' do
        expect(order.build_progress_hash).to eq({})
      end
    end
  end
end
