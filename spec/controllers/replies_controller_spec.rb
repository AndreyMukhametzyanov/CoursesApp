# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe RepliesController, type: :controller do
  let(:user) { create :user }
  let(:student) { create :user }
  let(:course) { create :course, author: user, students: [student] }
  let(:final_project) { create :final_project, course: course }
  let!(:user_project) { create :user_project, final_project: final_project, user: student }

  before { sign_in user }

  describe '#create' do
    context 'when time is over' do
      let(:alert_message) { I18n.t('errors.reply.time_is_over') }

      it 'correct redirect to start examination page and increase correct answers' do
        sign_in student
        travel_to(3.days.from_now) do
          post :create,
               params: { course_id: course.id,
                         reply: { user_reply: 'user', status: 'verification' } }

          expect(flash[:alert]).to eq(alert_message)
          expect(response).to redirect_to course_final_project_path(course)
        end
      end
    end

    context 'when user is owner' do
      let(:alert_message) { I18n.t('errors.reply.create_error') }

      before do
        post :create, params: { course_id: course.id, reply: { user_reply: 'test' } }
      end

      it 'return alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to(course_final_project_path(course))
      end
    end

    context 'when user is not owner' do
      before { sign_in student }

      context 'when data is valid' do
        let(:user_reply) { 'test' }
        let(:notice) { I18n.t('reply.create') }
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
        let(:another_file) do
          Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png'))
        end

        before do
          post :create,
               params: { course_id: course.id,
                         reply: { user_reply: 'user', status: 'verification', files: [file, another_file] } }
        end

        it 'return notice and correct redirect' do
          expect(flash[:notice]).to eq(notice)
          expect(response).to redirect_to(course_final_project_path(course))
        end
      end

      context 'when data is not valid' do
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
        let(:another_file) do
          Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png'))
        end

        before do
          post :create, params: { course_id: course.id, reply: { user_reply: '', status: 'verification' } }
        end

        it 'returns alert and correct redirect' do
          expect((assigns(:reply).errors)[:user_reply].first).to eq(error_msg)
          expect(response).to redirect_to(course_final_project_path(course))
        end
      end
    end
  end

  describe '#update' do
    let(:reply) { create :reply, user_project: user_project }

    context 'when user is owner' do
      context 'when data is correct'
      let(:teacher_comment) { 'test' }
      let(:notice) { I18n.t('reply.teacher_reply') }

      before do
        patch :update,
              params: { course_id: course.id, id: reply.id,
                        reply: { teacher_comment: teacher_comment, status: 'accepted' } }
      end

      it 'return notice and correct redirect' do
        expect(reply.reload.status).to eq('accepted')
        expect(reply.reload.teacher_comment).to eq(teacher_comment)
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(course_final_project_path(course))
      end
    end

    context 'when data is not correct' do
      let(:error_msg) { I18n.t('errors.lessons.blank_error') }

      before do
        patch :update, params: { course_id: course.id, id: reply.id, reply: { status: nil } }
      end

      it 'returns alert and correct redirect' do
        expect((assigns(:reply).errors)[:status].first).to eq(error_msg)
        expect(response).to redirect_to(course_final_project_path(course))
      end
    end
  end
end
