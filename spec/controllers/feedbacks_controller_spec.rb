# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe FeedbacksController, type: :controller do
  let(:user) { create :user }
  let(:course) { create :course }

  describe '#create' do
    context 'when sign in' do
      let(:body) { 'COOL WOW SUPER!' }
      let(:grade) { 5 }

      before { sign_in user }

      context 'when enrolled' do
        before { create :order, course: course, user: user }

        context 'when feedback exist' do
          before { create :feedback, user: user, course: course }

          it 'return alert flash and correct redirect' do
            expect do
              post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } }
            end.not_to change(Feedback, :count)

            expect(flash[:alert]).to be_present
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(promo_course_path(course))
          end
        end

        context 'when feedback is not exists' do
          let(:notice) { I18n.t('feedbacks.create.success') }
          let(:feedback) { course.feedbacks.first }

          it 'return success flash and correct redirect' do
            expect do
              post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } }
            end.to change(Feedback, :count).from(0).to(1)

            expect(feedback.body).to eq(body)
            expect(feedback.grade).to eq(grade)
            expect(flash[:notice]).to eq(notice)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(promo_course_path(course))
          end
        end
      end

      context 'when not enrolled' do
        let(:alert_message) { I18n.t('errors.courses.enrolled_error') }

        it 'return alert and correct redirect' do
          expect do
            post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } }
          end.not_to change(Feedback, :count)

          expect(flash[:alert]).to eq(alert_message)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end

      context 'when author' do
        let(:course) { create :course, author: user }

        it 'return alert and correct redirect' do
          expect do
            post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } }
          end.not_to change(Feedback, :count)

          expect(flash[:alert]).to be_present
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end
    end

    context 'when not sign in' do
      before { post :create, params: { course_id: course.id, feedback: { body: 'body', grade: 'grade' } } }

      it 'return alert and correct redirect' do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
