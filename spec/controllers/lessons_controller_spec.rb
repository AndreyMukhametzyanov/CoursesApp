# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe LessonsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#new' do
    context 'when user not owner of course' do
      let!(:course) { create :course, user: user }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :new, params: { course_id: course.id }
      end

      it 'should return alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end

    context 'when user is owner of course' do
      let!(:course) { create :course, user: user }

      before { get :new, params: { course_id: course.id } }

      it 'should be correct render form' do
        expect(response).to have_http_status(200)
        expect(response).to render_template('new')
      end
    end
  end

  describe '#create' do
    context 'when user is owner' do
      let!(:course) { create :course, user: user }

      context 'when lesson is valid' do
        let!(:title) { 'Lesson' }
        let!(:content) { 'test' }
        let(:one_lesson) { course.lessons.last }

        before do
          post :create, params: { course_id: course.id, lesson: { title: 'Lesson', youtube_video_id: '',
                                                                  content: 'test',
                                                                  order_factor: 1 } }
        end

        it 'should render correct page' do
          expect(one_lesson.title).to eq(title)
          expect(one_lesson.content).to eq(content)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(course_lesson_path(course, one_lesson))
        end
      end

      context 'when lesson is not valid' do
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before { post :create, params: { course_id: course.id, lesson: { title: '' } } }

        it 'should return errors' do
          expect((assigns(:lesson).errors)[:title].first).to eq(error_msg)
          expect(response).to have_http_status(200)
          expect(response).to render_template('new')
        end
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, user: user }
      let(:new_user) { create :user }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }

      before do
        sign_in new_user
        post :create, params: { course_id: course.id, lesson: { title: 'Lesson', youtube_video_id: '',
                                                                content: 'test',
                                                                order_factor: 1 } }
      end

      it 'should return errors' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#show' do
    let!(:course) { create :course, user: user }
    let!(:lesson) { create :lesson, course: course }

    before { get :show, params: { course_id: course.id, id: lesson.id } }

    it 'should should returns correct render' do
      expect(assigns(:lesson)).to eq(lesson)
      expect(assigns(:course)).to eq(course)
      expect(response).to have_http_status(200)
      expect(response).to render_template('show')
    end
  end

  describe '#edit' do
    context 'when user is owner' do
      let!(:course) { create :course, user: user }
      let!(:lesson) { create :lesson, course: course }

      before { get :edit, params: { course_id: course.id, id: lesson.id } }

      it 'should be correct render form ' do
        expect(assigns(:course)).to eq(course)
        expect(response).to have_http_status(200)
        expect(response).to render_template('edit')
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, user: user }
      let!(:lesson) { create :lesson, course: course }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :edit, params: { course_id: course.id, id: lesson.id }
      end

      it 'should return alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#update' do
    context 'when user is owner' do
      context 'when data is correct' do
        let(:new_title) { 'new lesson' }
        let!(:course) { create :course, user: user }
        let!(:lesson) { create :lesson, course: course }

        before { patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } } }

        it 'should update course and check redirect to root' do
          expect(lesson.reload.title).to eq(new_title)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(course_lesson_path(course, lesson))
        end
      end

      context 'when data does not correct' do
        let(:new_title) { '' }
        let!(:course) { create :course, user: user }
        let!(:lesson) { create :lesson, course: course }
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before { patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } } }

        it 'should return error' do
          expect((assigns(:lesson).errors)[:title].first).to eq(error_msg)
          expect(response).to have_http_status(200)
          expect(response).to render_template('edit')
        end
      end

      context 'when user is not owner' do
        let!(:course) { create :course, user: user }
        let!(:lesson) { create :lesson, course: course }
        let(:new_user) { create :user }
        let(:alert_message) { I18n.t('errors.lessons.change_error') }
        let(:new_title) { '' }

        before do
          sign_in new_user
          patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } }
        end

        it 'should return errors' do
          expect(flash[:alert]).to eq(alert_message)
          expect(response).to redirect_to promo_course_path(course)
        end
      end
    end
  end
end
