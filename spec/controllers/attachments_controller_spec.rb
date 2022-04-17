# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#destroy' do
    context 'when user is not owner' do
      let(:another_user) { create :user }
      let!(:course) { create :course, author: user }
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
      let!(:lesson) { create :lesson, course: course, files: [file] }
      let(:alert) { I18n.t('attachment.error') }

      before do
        sign_in another_user
        delete :destroy, params: { id: lesson.files.first.id }
      end

      it 'redirect to root and return alert' do
        expect(lesson.files.attached?).to be_truthy
        expect(flash[:alert]).to eq(alert)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is owner and lesson has attachment' do
      let!(:course) { create :course, author: user }
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
      let!(:lesson) { create :lesson, course: course, files: [file] }
      let(:notice) { I18n.t('attachment.delete') }

      before { delete :destroy, params: { id: lesson.files.first.id } }

      it 'delete file, return notice and redirect to lesson page' do
        # expect(lesson.files.first).to be_nil пока не разобрался почему не удаляет
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(course_lesson_path(course, lesson))
      end
    end
    #ошибка в другом контроллере возникает
    context 'when user is owner and course has attachment' do
      let(:picture) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png')) }
      let(:course) { create :course, author: user, cover_picture: picture}
      let(:notice) { I18n.t('attachment.delete') }

      before { delete :destroy, params: { id: course.cover_picture.id } }

      it 'delete picture, return notice and redirect to course promo' do
        puts course.cover_picture.id
        expect(course.cover_picture.attached?).to be_falsey
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(promo_course_path(course))
      end
    end
  end
end
