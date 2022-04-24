# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe LessonsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#new' do
    context 'when user not owner of course' do
      let!(:course) { create :course, author: user }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :new, params: { course_id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end

    context 'when user is owner of course' do
      let!(:course) { create :course, author: user }

      before { get :new, params: { course_id: course.id } }

      it 'is correct render form' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('new')
      end
    end
  end

  describe '#create' do
    context 'when user is owner' do
      let!(:course) { create :course, author: user }

      context 'when lesson is valid' do
        let!(:title) { 'Lesson' }
        let!(:content) { 'test' }
        let(:one_lesson) { course.lessons.last }
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
        let(:another_file) do
          Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png'))
        end

        let(:links) { [{ address: 'https://www.google.com/' }, { address: 'https://www.ya.ru/' }] }

        before do
          post :create, params: { course_id: course.id, lesson: { title: 'Lesson', youtube_video_id: '',
                                                                  content: 'test', order_factor: 1,
                                                                  files: [file, another_file],
                                                                  links_attributes: links } }
        end

        it 'renders correct page' do
          expect(one_lesson.links.count).to eq(links.count)
          expect(one_lesson.title).to eq(title)
          expect(one_lesson.content).to eq(content)
          expect(one_lesson.files).to be_attached
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(course_lesson_path(course, one_lesson))
        end
      end

      context 'when lesson is not valid' do
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before { post :create, params: { course_id: course.id, lesson: { title: '' } } }

        it 'returns errors' do
          expect((assigns(:lesson).errors)[:title].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('new')
        end
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, author: user }
      let(:new_user) { create :user }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }

      before do
        sign_in new_user
        post :create, params: { course_id: course.id, lesson: { title: 'Lesson', youtube_video_id: '',
                                                                content: 'test',
                                                                order_factor: 1 } }
      end

      it 'returns errors' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#show' do
    let!(:course) { create :course, author: user }
    let!(:lesson) { create :lesson, course: course }

    context 'when user is enrolled in course' do
      before do
        create :order, user: user, course: course
        get :show, params: { course_id: course.id, id: lesson.id }
      end

      it 'return correct render' do
        expect(assigns(:lesson)).to eq(lesson)
        expect(assigns(:course)).to eq(course)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('show')
      end
    end

    context 'when user is not enrolled in course' do
      let(:new_user) { create :user }
      let(:error_msg) { I18n.t 'errors.lessons.access_error' }

      before do
        sign_in new_user
        get :show, params: { course_id: course.id, id: lesson.id }
      end

      it 'return correct render' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#edit' do
    context 'when user is owner' do
      let!(:course) { create :course, author: user }
      let!(:lesson) { create :lesson, course: course }

      before { get :edit, params: { course_id: course.id, id: lesson.id } }

      it 'is correct render form' do
        expect(assigns(:course)).to eq(course)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('edit')
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, author: user }
      let!(:lesson) { create :lesson, course: course }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :edit, params: { course_id: course.id, id: lesson.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#update' do
    context 'when user is owner' do
      context 'when data is correct' do
        let(:new_title) { 'new lesson' }
        let!(:course) { create :course, author: user }
        let!(:lesson) { create :lesson, course: course }

        before { patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } } }

        it 'updates course and check redirect to root' do
          expect(lesson.reload.title).to eq(new_title)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(course_lesson_path(course, lesson))
        end
      end

      context 'when data does not correct' do
        let(:new_title) { '' }
        let!(:course) { create :course, author: user }
        let!(:lesson) { create :lesson, course: course }
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before { patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } } }

        it 'returns error' do
          expect((assigns(:lesson).errors)[:title].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('edit')
        end
      end

      context 'when user is not owner' do
        let!(:course) { create :course, author: user }
        let!(:lesson) { create :lesson, course: course }
        let(:new_user) { create :user }
        let(:alert_message) { I18n.t('errors.lessons.change_error') }
        let(:new_title) { '' }

        before do
          sign_in new_user
          patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } }
        end

        it 'returns errors' do
          expect(flash[:alert]).to eq(alert_message)
          expect(response).to redirect_to promo_course_path(course)
        end
      end
    end
  end
end
