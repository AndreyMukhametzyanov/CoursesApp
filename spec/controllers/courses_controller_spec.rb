# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe CoursesController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#index' do
    let!(:courses) { create_list :course, 3 }

    before { get :index }

    it 'returnses correct renders for #index' do
      expect(response).to have_http_status(:ok)
      expect(assigns(:courses)).to eq(courses)
      expect(response).to render_template('index')
    end
  end

  describe '#create' do
    context 'when new course is valid' do
      let(:name) { 'Course' }
      let(:description) { 'test' }
      let(:level) { 1 }
      let(:course) { Course.last }

      before { post :create, params: { course: { name: 'Course', video_link: '', description: 'test', level: 1 } } }

      it 'renders correct page' do
        expect(course.name).to eq(name)
        expect(course.description).to eq(description)
        expect(course.level).to eq(level)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(courses_path)
      end
    end

    context 'when new course is not valid' do
      it 'renders new form' do
        post :create, params: { course: { name: 'Course', video_link: 'asdsa', description: 'test', level: 1 } }
        expect(Course.count).to eq(0)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('new')
      end
    end
  end

  describe '#edit' do
    context 'when user is owner' do
      let!(:course) { create :course, user: user }

      before { get :edit, params: { id: course.id } }

      it 'returnses correct renders for #edit' do
        expect(assigns(:course)).to eq(course)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('edit')
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, user: user }
      let(:user2) { create :user }
      let(:alert_message) { I18n.t('errors.courses.change_error') }

      before do
        sign_in user2
        get :edit, params: { id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to courses_path
      end
    end
  end

  describe '#update' do
    context 'when user is owner' do
      context 'when data is correct' do
        let(:new_name) { 'new name' }
        let!(:course) { create :course, user: user }

        before { patch :update, params: { id: course.id, course: { name: new_name } } }

        it 'updates course and check redirect to root' do
          expect(course.reload.name).to eq(new_name)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(courses_path)
        end
      end

      context 'when data is not correct' do
        let(:new_name) { '' }
        let!(:course) { create :course, user: user }
        let(:error_msg) { I18n.t('errors.courses.blank_error') }

        before { patch :update, params: { id: course.id, course: { name: new_name } } }

        it 'returns errors' do
          expect((assigns(:course).errors)[:name].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when user does not owner this course' do
      let!(:course) { create :course, user: user }
      let(:another_user) { create :user }
      let(:alert_message) { I18n.t('errors.courses.change_error') }

      before do
        sign_in another_user
        patch :update, params: { id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to courses_path
      end
    end
  end

  describe '#promo' do
    let!(:course) { create :course, user: user }

    before { get :promo, params: { id: course.id } }

    it 'returnses correct renders for #promo' do
      expect(assigns(:course)).to eq(course)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('promo')
    end
  end

  describe '#start' do
    context 'when a lesson exists' do
      let!(:course) { create :course, user: user }
      let!(:lesson) { create :lesson, course: course }

      before { get :start, params: { id: course.id } }

      it 'returnses correct redirect to start lesson page' do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(course_lesson_path(course, lesson))
      end
    end

    context 'when a lesson does not exists' do
      let!(:course) { create :course, user: user }
      let(:alert_message) { I18n.t('errors.courses.access_error') }

      before { get :start, params: { id: course.id } }

      it 'returns alarm and correct redirect to promo page' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path
      end
    end
  end
end
