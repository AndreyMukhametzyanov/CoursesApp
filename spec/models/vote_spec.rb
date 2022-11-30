# frozen_string_literal: true

# == Schema Information
#
# Table name: votes
#
#  id         :bigint           not null, primary key
#  kind       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lesson_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_votes_on_lesson_id              (lesson_id)
#  index_votes_on_user_id                (user_id)
#  index_votes_on_user_id_and_lesson_id  (user_id,lesson_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (lesson_id => lessons.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Vote do
  subject(:vote) { build(:vote) }

  describe 'validations' do
    it {
      expect(vote).to define_enum_for(:kind)
        .with_values(dislike: 'dislike', like: 'like')
        .backed_by_column_of_type(:string)
    }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:lesson_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:lesson) }
    it { is_expected.to belong_to(:user) }
  end
end
