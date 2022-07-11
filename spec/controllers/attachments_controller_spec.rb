# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#destroy' do
    let(:picture) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png')) }
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
    let!(:course) { create :course, author: user, cover_picture: picture }
    let!(:lesson) { create :lesson, course: course, files: [file] }

    context 'when user is not owner' do
      let(:another_user) { create :user }

      before do
        sign_in another_user
        delete :destroy, params: { id: lesson.files.first.id }
      end

      it 'redirect to root and return alert' do
        expect(lesson.files).to be_attached
      end
    end

    context 'when user is owner and lesson has attachment' do
      before do
        delete :destroy, params: { id: lesson.files.first.id }, format: 'js'
        lesson.reload
      end

      it 'delete file' do
        expect(lesson.files).not_to be_attached
      end
    end

    context 'when user is owner and course has attachment' do
      before do
        delete :destroy, params: { id: course.cover_picture.id }, format: 'js'
        course.reload
      end

      it 'delete picture' do
        expect(course.cover_picture).not_to be_attached
      end
    end
  end
end
