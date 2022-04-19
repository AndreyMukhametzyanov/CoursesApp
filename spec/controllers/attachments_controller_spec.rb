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
      let(:alert) { I18n.t('attachment.error') }

      before do
        sign_in another_user
        delete :destroy, params: { id: lesson.files.first.id }
      end

      it 'redirect to root and return alert' do
        expect(lesson.files).to be_attached
        expect(flash[:alert]).to eq(alert)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is owner and lesson has attachment' do
      let(:notice) { I18n.t('attachment.delete') }

      before do
        delete :destroy, params: { id: lesson.files.first.id }
        lesson.reload
      end

      it 'delete file, return notice and redirect to lesson page' do
        expect(lesson.files).not_to be_attached
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(course_lesson_path(course, lesson))
      end
    end

    context 'when user is owner and course has attachment' do
      let(:notice) { I18n.t('attachment.delete') }

      before do
        delete :destroy, params: { id: course.cover_picture.id }
        course.reload
      end

      it 'delete picture, return notice and redirect to course promo' do
        expect(course.cover_picture).not_to be_attached
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(promo_course_path(course))
      end
    end
  end
end
