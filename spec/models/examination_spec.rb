# frozen_string_literal: true

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
