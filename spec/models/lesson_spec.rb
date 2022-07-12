# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :bigint           not null, primary key
#  complete         :boolean          default(FALSE)
#  content          :text
#  order_factor     :integer
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  course_id        :bigint           not null
#  youtube_video_id :text
#
# Indexes
#
#  index_lessons_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
require 'rails_helper'

RSpec.describe Lesson, type: :model do
  subject { build(:lesson) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to have_many_attached(:files) }
    it { is_expected.to have_many(:links) }
    it { is_expected.to accept_nested_attributes_for :links }
  end

  describe 'owned by user' do
    let!(:course) { create :course }
    let!(:lesson) { create :lesson, course: course }

    it 'is owner' do
      expect(lesson).to be_owner(course.author)
    end
  end
end
