# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe FeedbacksController, type: :controller do
  let(:user) { create :user }
  let(:course) { create :course }

  describe '#create' do
    let(:body) { 'COOL WOW SUPER!' }
    let(:grade) { 5 }
    let(:notice) { I18n.t('feedbacks.create.success') }

    context 'when sign in' do
      before { sign_in user }

      context 'when enrolled' do
        let!(:order) { create :order, course: course, user: user }

        before { post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } } }

        context 'when feedback exist' do
          let!(:feedback) { Feedback.create(body: body, grade: 3, course: course, user: user) }
          let(:alert_message) { feedback.errors.full_messages.first }

          it 'return alert flash and correct redirect' do
            puts alert_message
            expect(flash[:alert]).to eq(alert_message)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(promo_course_path(course))
          end
        end

        context 'when feedback is not exists' do
          it 'return success flash and correct redirect' do
            expect(course.feedbacks.first.body).to eq(body)
            expect(course.feedbacks.first.grade).to eq(grade)
            expect(flash[:notice]).to eq(notice)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(promo_course_path(course))
          end
        end
      end

      context 'when not enrolled' do
        let(:alert_message) { I18n.t('errors.courses.enrolled_error') }

        before { post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } } }

        it 'return alert and correct redirect' do
          expect(flash[:alert]).to eq(alert_message)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end

      context 'when author' do
        let(:course) { create :course, author: user }
        let(:alert_message) { I18n.t('feedbacks.author_error') }

        before { post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } } }

        it 'return alert and correct redirect' do
          expect(flash[:alert]).to eq(alert_message)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end
    end

    context 'when not sign in' do

      before { post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } } }

      it 'return alert and correct redirect' do

      end
    end
  end

end
