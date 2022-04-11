# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  subject(:course) { build(:course) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:level) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_numericality_of(:level).is_greater_than_or_equal_to(1).is_less_than(6) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:author) }
  end

  describe 'custom validation' do
    context 'when link is not youtube hosting' do
      let(:error_message) { I18n.t('activerecord.errors.models.course.attributes.video_link.is_not_youtube_link') }

      before { course.video_link = 'test_link' }

      it 'is not valid' do
        expect(course).not_to be_valid
        expect(course.errors.messages[:video_link].to_sentence).to eq(error_message)
      end
    end

    context 'when link is youtube hosting' do
      before { course.video_link = 'https://www.youtube.com/watch?v=sKwibmEWjdU' }

      it 'is valid' do
        expect(course).to be_valid
      end
    end

    context 'when link is empty' do
      before { course.video_link = '' }

      it 'is valid for empty link' do
        expect(course).to be_valid
      end
    end

    context 'when link is nil' do
      before { course.video_link = nil }

      it 'is valid for nil link' do
        expect(course).to be_valid
      end
    end
  end

  describe 'create model' do
    let(:my_user) { build(:user) }
    let!(:my_course) { build(:course) }
    let(:valid_link) { 'https://www.youtube.com/watch?v=sKwibmEWjdU' }
    let(:invalid_link) { 'https://www.yout111ube.com/watch?v=sKwibmEWjdU' }
    let(:empty_link) { nil }

    context 'when valid link' do
      before do
        my_course.video_link = valid_link
        my_course.save
      end

      it 'is create model' do
        expect("https://www.youtube.com/watch?v=#{my_course.youtube_video_id}").to eq(valid_link)
      end
    end

    context 'when not valid link' do
      let(:error_msg) { I18n.t('activerecord.errors.models.course.attributes.video_link.is_not_youtube_link') }

      before do
        my_course.video_link = invalid_link
        my_course.save
      end

      it 'is not create model' do
        expect(my_course.errors.messages[:video_link].to_sentence).to eq(error_msg)
      end
    end

    context 'when empty link' do
      before do
        my_course.video_link = ''
        my_course.save
      end

      it 'is valid' do
        expect(my_course.youtube_video_id).to eq(nil)
      end
    end

    context 'when nil link' do
      before do
        my_course.video_link = nil
        my_course.save
      end

      it 'is valid' do
        expect(my_course.youtube_video_id).to eq(nil)
      end
    end

    context 'when user owner or not' do
      let(:second_user) { build(:user) }
      let(:course) { create :course, author: my_user }

      it 'is owner' do
        expect(course.author).to eq(my_user)
      end

      it 'is not owner' do
        expect(course.author).to_not eq(second_user)
      end

    end
  end
end
