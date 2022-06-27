# frozen_string_literal: true

# == Schema Information
#
# Table name: feedbacks
#
#  id         :bigint           not null, primary key
#  body       :text
#  grade      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_feedback_on_course_id_and_user_id  (user_id,course_id) UNIQUE
#  index_feedbacks_on_course_id             (course_id)
#  index_feedbacks_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Feedback, type: :model do
  subject { build(:feedback) }

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to allow_value(nil).for(:body) }
    it { is_expected.to validate_presence_of(:grade) }
    it { is_expected.to validate_numericality_of(:grade).is_greater_than_or_equal_to(1).is_less_than(6) }
  end
end
