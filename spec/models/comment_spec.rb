# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_least(2) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:commentable) }
  end
end
