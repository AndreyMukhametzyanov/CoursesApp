# frozen_string_literal: true

# == Schema Information
#
# Table name: final_projects
#
#  id                :bigint           not null, primary key
#  description       :text
#  execution_days    :integer
#  short_description :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course_id         :bigint           not null
#
# Indexes
#
#  index_final_projects_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
require 'rails_helper'

RSpec.describe FinalProject do
  subject { build(:final_project) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:short_description) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_numericality_of(:execution_days).is_greater_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to have_many(:user_projects) }
    it { is_expected.to delegate_method(:owner?).to(:course) }
  end

  describe 'after create callback' do
    let(:order) { create(:order, course: subject.course) }

    it 'return correct lessons count in order' do
      expect(order.project_complete).to be_falsey
    end
  end
end
