# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe FinalProjectsController, type: :controller do
  let(:user) { create :user }
  let(:course) { create :course, author: user }

  before { sign_in user }

  describe '#new' do
    context 'when user is owner' do
      before { get :new, params: { course_id: course.id } }

      it 'is correct render form' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('new')
      end
    end

    context 'when final project already exist' do
      before do
        create :final_project, course: course
        get :new, params: { course_id: course.id }
      end

      it 'is correct render form' do
        expect(response).to redirect_to(edit_course_final_project_path(course))
      end
    end

    context 'when user is not owner' do
      let(:new_user) { create :user }
      let(:alert_message) { I18n.t('errors.final_project.change_error') }

      before do
        sign_in new_user
        get :new, params: { course_id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to(promo_course_path(course))
      end
    end
  end

  describe '#create' do
    context 'when user is owner' do
      let(:description) { "<div class=\"trix-content\">\n  test\n</div>\n" }
      let(:short_description) { 'final project' }
      let(:days) { 1 }
      let(:notice) { I18n.t('final_project.create') }
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
      let(:another_file) do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png'))
      end

      before do
        post :create, params: { course_id: course.id, final_project: { description: 'test',
                                                                       short_description: short_description,
                                                                       execution_days: days,
                                                                       files: [file, another_file] } }
      end

      it 'renders correct page and success alert' do
        expect(course.final_project.files).to be_any
        expect(course.final_project.description.to_s).to eq(description)
        expect(course.final_project.short_description).to eq(short_description)
        expect(course.final_project.execution_days).to eq(days)
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(promo_course_path(course))
      end

      context 'when final project is not valid' do
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before do
          post :create, params: { course_id: course.id, final_project: { description: '',
                                                                         short_description: 'test',
                                                                         execution_days: 1 } }
        end

        it 'returns alert and correct redirect' do
          expect(assigns(:final_project).errors[:description].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('new')
        end
      end
    end

    context 'when user is not owner' do
      let(:new_user) { create :user }
      let(:alert_message) { I18n.t('errors.final_project.change_error') }

      before do
        sign_in new_user
        post :create, params: { course_id: course.id, final_project: { description: 'test',
                                                                       short_description: 'test',
                                                                       execution_days: 1 } }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to(promo_course_path(course))
      end
    end
  end

  describe '#update' do
    let!(:final_project) { create :final_project, course: course }

    context 'when user is owner' do
      context 'when data is correct' do
        let(:days) { 2 }
        let(:notice) { I18n.t('final_project.update') }

        before { patch :update, params: { course_id: course.id, final_project: { execution_days: days } } }

        it 'updates final project and check redirect' do
          expect(final_project.reload.execution_days).to eq(days)
          expect(response).to have_http_status(:found)
          expect(flash[:notice]).to eq(notice)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end

      context 'when data does not correct' do
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before { patch :update, params: { course_id: course.id, final_project: { execution_days: nil } } }

        it 'returns error' do
          expect(assigns(:final_project).errors[:execution_days].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when user is not owner' do
      let(:new_user) { create :user }
      let(:days) { 2 }
      let(:alert_message) { I18n.t('errors.final_project.change_error') }

      before do
        sign_in new_user
        patch :update, params: { course_id: course.id, final_project: { execution_days: days } }
      end

      it 'returns errors' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#show' do
    let!(:final_project) { create :final_project, course: course }

    context 'when user is owner or enrolled in course' do
      before do
        create :order, user: user, course: course
        get :show, params: { course_id: course.id }
      end

      it 'return correct render' do
        expect(assigns(:final_project)).to eq(final_project)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('show')
      end
    end

    context 'when user is not owner or not enrolled in course' do
      let(:error_msg) { I18n.t('errors.final_project.access_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :show, params: { course_id: course.id }
      end

      it 'return correct render' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#start' do
    let(:student) { create :user }
    let!(:final_project) { create :final_project, course: course }

    context 'when user is not owner or not enrolled in course' do
      let(:error_msg) { I18n.t('errors.courses.enrolled_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        post :start, params: { course_id: course.id }
      end

      it 'return correct render' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to promo_course_path(course)
      end
    end

    context 'when final project exist' do
      let(:user_project) { final_project.user_projects.last }

      before do
        sign_in student
        create :order, user: student, course: course
        post :start, params: { course_id: course.id }
      end

      it 'return correct render' do
        expect(final_project.user_projects.find_by(user_id: student.id)).not_to be_nil
        expect(response).to redirect_to course_final_project_path(course)
      end
    end

    context 'when final project not exist' do
      let(:new_course) { create :course, author: user, lessons: [(create :lesson)] }
      let(:alert) { I18n.t('errors.final_project.not_create') }

      before do
        create :order, user: user, course: new_course
        post :start, params: { course_id: new_course.id }
      end

      it 'return correct render' do
        expect(flash[:alert]).to eq(alert)
        expect(response).to redirect_to promo_course_path(new_course.id)
      end
    end
  end
end
