# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:exam) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to accept_nested_attributes_for :answers }
  end
end
