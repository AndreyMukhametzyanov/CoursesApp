# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id             :bigint           not null, primary key
#  body           :string
#  correct_answer :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  question_id    :bigint           not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
require 'rails_helper'

RSpec.describe Answer do
  subject { build(:answer) }

  describe 'associations' do
    it { is_expected.to belong_to(:question) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end
end
