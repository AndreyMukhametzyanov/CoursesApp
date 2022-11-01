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

RSpec.describe Examination do
  subject(:examination) do
    described_class.create(user: user, exam: exam, passage_time: exam.attempt_time,
                           number_of_questions: exam.questions.count, current_question: exam.questions.first,
                           next_question: exam.questions.second)
  end

  let!(:user) { create(:user) }
  let!(:course) { create(:course, author: user) }

  let(:exam) do
    Exam.create(course: course, title: 'MyExam', description: 'Text', attempts_count: 1, attempt_time: 120,
                questions_attributes: questions)
  end

  let(:answers) { [{ body: 'yes', correct_answer: true }, { body: 'no', correct_answer: false }] }
  let(:another_answers) { [{ body: 'yes', correct_answer: false }, { body: 'no', correct_answer: true }] }
  let(:questions) do
    [{ title: 'First?', answers_attributes: answers },
     { title: 'Second?', answers_attributes: another_answers }]
  end

  describe 'associations' do
    it { is_expected.to belong_to(:exam) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:current_question) }
  end

  describe '.time_remaining' do
    let(:time) { (examination.created_at + exam.attempt_time) - Time.zone.now }

    it 'returns correct data' do
      expect(examination.time_remaining - time).to be < 0.1
    end
  end

  describe '.create_default' do
    let(:another_examination) do
      described_class.create_default(user: user, exam: exam, current_question: exam.questions.first,
                                     next_question: exam.questions.second)
    end

    it 'return valid data' do
      expect(another_examination).to be_valid
      expect(another_examination.number_of_questions).to eq(0)
    end
  end
end
