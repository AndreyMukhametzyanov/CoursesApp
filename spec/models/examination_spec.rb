# frozen_string_literal: true

# == Schema Information
#
# Table name: examinations
#
#  id                  :bigint           not null, primary key
#  correct_answers     :integer          default(0)
#  finished_exam       :boolean          default(FALSE)
#  number_of_questions :integer          default(0)
#  passage_time        :integer          default(0)
#  passed_exam         :boolean          default(FALSE)
#  percentage_passing  :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  current_question_id :bigint
#  exam_id             :bigint           not null
#  next_question_id    :bigint
#  user_id             :bigint           not null
#
# Indexes
#
#  index_examinations_on_current_question_id  (current_question_id)
#  index_examinations_on_exam_id              (exam_id)
#  index_examinations_on_next_question_id     (next_question_id)
#  index_examinations_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (current_question_id => questions.id)
#  fk_rails_...  (exam_id => exams.id)
#  fk_rails_...  (next_question_id => questions.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Examination, type: :model do
  # subject { build(:examination) }
  subject(:examination) do
    described_class.create(user: current_user, exam: exam, passage_time: exam.attempt_time,
                          number_of_questions: exam.questions.count,
                          current_question: exam.questions.first,
                          next_question: exam.questions.second)
  end

  let!(:current_user) { create(:user) }
  let!(:exam) { create(:exam) }

  describe 'associations' do
    it { is_expected.to belong_to(:exam) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:current_question) }
  end

  describe '.time_remaining' do
    it 'returns correct data' do
      puts examination.errors.inspect

      expect(examination.reload.time_remaining).to eq(30)
    end

  end
end
