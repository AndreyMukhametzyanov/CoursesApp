# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe CoursesController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#index' do
    let!(:courses) { create_list :course, 3 }

    before { get :index }

    it 'returns correct renders for #index' do
      expect(response).to have_http_status(:ok)
      expect(assigns(:courses)).to match_array(courses)
      expect(response).to render_template('index')
    end
  end

  describe '#create' do
    context 'when new course is valid' do
      let(:name) { 'Course' }
      let(:description) { "<div class=\"trix-content\">\n  test\n</div>\n" }
      let(:short_description) { 'test' }
      let(:level) { 1 }
      let(:course) { Course.last }
      let(:picture) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png')) }

      before do
        post :create, params: { course: { name: 'Course', video_link: '', short_description: short_description,
                                          description: 'test', level: 1, cover_picture: picture } }
      end

      it 'renders correct page' do
        expect(course.name).to eq(name)
        expect(course.cover_picture).to be_attached
        expect(course.short_description.to_s).to eq(short_description)
        expect(course.description.to_s).to eq(description)
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
      let!(:course) { create :course, author: user }

      before { get :edit, params: { id: course.id } }

      it 'returnses correct renders for #edit' do
        expect(assigns(:course)).to eq(course)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('edit')
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, author: user }
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
        let!(:course) { create :course, author: user }

        before { patch :update, params: { id: course.id, course: { name: new_name } } }

        it 'updates course and check redirect to root' do
          expect(course.reload.name).to eq(new_name)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(courses_path)
        end
      end

      context 'when data is not correct' do
        let(:new_name) { '' }
        let!(:course) { create :course, author: user }
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
      let!(:course) { create :course, author: user }
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
    let!(:course) { create :course, author: user }

    before { get :promo, params: { id: course.id } }

    it 'returnses correct renders for #promo' do
      expect(assigns(:course)).to eq(course)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('promo')
    end
  end

  describe '#start' do
    context 'when user is not enrolled in course' do
      let!(:course) { create :course, author: user }
      let(:another_user) { create :user }
      let(:student) { course.students.find_by(id: another_user.id) }
      let(:alert_message) { I18n.t('errors.courses.enrolled_error') }

      before do
        sign_in another_user
        get :start, params: { id: course.id }
      end

      it 'returns alarm and correct redirect to promo page' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path
      end
    end

    context 'when user is enrolled in course' do
      context 'when a lesson exists' do
        let!(:course) { create :course }
        let!(:lesson) { create :lesson, course: course }

        before do
          create :order, user: user, course: course
          get :start, params: { id: course.id }
        end

        it 'returns correct redirect to start lesson page' do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(course_lesson_path(course, lesson))
        end
      end

      context 'when a lesson does not exists' do
        let!(:course) { create :course, author: user }
        let(:alert_message) { I18n.t('errors.lessons.access_error') }

        before do
          create :order, user: user, course: course
          get :start, params: { id: course.id }
        end

        it 'returns alarm and correct redirect to promo page' do
          expect(flash[:alert]).to eq(alert_message)
          expect(response).to redirect_to promo_course_path
        end
      end
    end
  end

  describe '#order' do
    context 'when order created' do
      let!(:course) { create :course, author: user }
      let(:success_message) { I18n.t 'orders.create_order.success' }
      let(:order) { Order.find_by(user_id: user.id, course: course) }

      before { post :order, params: { id: course.id } }

      it 'renders success message and correct render form' do
        expect(assigns(:order)).to eq(order)
        expect(order.total_lessons).to eq(course.lessons.count)
        expect(order.completed_lessons_ids).to be_empty
        expect(order.exam_complete).to be_nil
        expect(order.project_complete).to be_nil
        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to eq(success_message)
        expect(response).to redirect_to promo_course_path(course.id)
      end
    end

    context 'when order is not created' do
      let!(:course) { create :course, author: user }
      let(:error_message) { I18n.t 'orders.create_order.error' }

      before do
        create :order, user: user, course: course
        post :order, params: { id: course.id }
      end

      it 'renders error message and redirect to root' do
        expect(flash[:alert]).to eq(error_message)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
      end
    end
  end
end
