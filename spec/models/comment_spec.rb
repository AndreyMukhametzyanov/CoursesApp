# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment) }

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(2) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }
  end
end
