# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  subject { build(:course) }
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:level) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_numericality_of(:level).is_greater_than_or_equal_to(1).is_less_than(6) }
  end
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'custom validation' do
    context 'when link is not youtube hosting' do
      let(:error_message) { 'this link is not from YouTube hosting' }

      it 'should be not valid' do
        subject.video_link = 'test_link'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:video_link].to_sentence).to eq(error_message)
      end
    end
    context 'when link is not youtube hosting' do
      it 'should be valid' do
        subject.video_link = 'https://www.youtube.com/watch?v=sKwibmEWjdU'
        expect(subject).to be_valid
      end
    end

    context 'when link is empty' do
      it 'should be valid for empty link' do
        subject.video_link = ''
        expect(subject).to be_valid
      end
    end

    context 'when link is nil' do
      it 'should be valid for nil link' do
        subject.video_link = nil
        expect(subject).to be_valid
      end
    end
  end

  describe 'create model' do
    let(:my_user) { build(:user) }
    let!(:my_course) { build(:course) }
    let(:valid_link) { 'https://www.youtube.com/watch?v=sKwibmEWjdU' }
    let(:invalid_link) { 'https://www.yout111ube.com/watch?v=sKwibmEWjdU' }
    let(:empty_link) { nil }

    context 'valid link' do
      it 'should be create model' do
        my_course.video_link = valid_link
        my_course.save
        expect("https://www.youtube.com/watch?v=#{my_course.youtube_video_id}").to eq(valid_link)
      end
    end

    context 'not valid link' do
      let(:error_msg) { 'this link is not from YouTube hosting' }

      it 'should be not create model' do
        my_course.video_link = invalid_link
        my_course.save
        expect(my_course.errors.messages[:video_link].to_sentence).to eq(error_msg)
      end
    end

    context 'empty link' do
      it 'should be valid' do
        my_course.video_link = ''
        my_course.save
        expect(my_course.youtube_video_id).to eq(nil)
      end
    end

    context 'nil link' do
      it 'should be valid' do
        my_course.video_link = nil
        my_course.save
        expect(my_course.youtube_video_id).to eq(nil)
      end
    end
  end
end
