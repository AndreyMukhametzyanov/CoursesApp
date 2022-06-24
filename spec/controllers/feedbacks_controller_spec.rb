# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe FeedbacksController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#create' do
    let!(:course) { create :course }
    let(:body) { 'COOL' }
    let(:grade) { 5 }
    let(:alert_message) { I18n.t('feedbacks.create.error') }
    let(:notice) { I18n.t('feedbacks.create.success') }

    context 'when the user enrolled in course' do
      let!(:order) { create :order, course: course, user: another_user }

      context 'when feedback was created' do
        before do
          post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } }
        end

        it 'return success flash and correct redirect' do
          expect(course.feedbacks.first.body).to eq(body)
          expect(course.feedbacks.first.grade).to eq(grade)
          expect(flash[:notice]).to eq(notice)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(courses_path)
        end
      end

      context 'when feedback was not created' do
        before { post :create, params: { course_id: course.id, feedback: { grade: grade } } }

        it 'return alert flash and correct redirect' do
          expect(course.feedbacks.all).to be_empty
          expect(response).to have_http_status(:found)
          expect(flash[:alert]).to eq(alert_message)
          expect(response).to redirect_to(courses_path)
        end
      end
    end
  end

  describe '#create2' do
    let(:user) { create :user }
    let(:course) { create :course }
    let(:body) { 'COOL WOW SUPER!' }
    let(:grade) { 5 }
    let(:alert_message) { I18n.t('feedbacks.create.error') }
    let(:notice) { I18n.t('feedbacks.create.success') }

    context 'when sign in' do
      before { sign_in user }

      context 'when enrolled' do
        let!(:order) { create :order, course: course, user: user }

        before { post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } } }

        context 'when feedback exist' do
          # let!(:feedback) { create :feedback, course: course, user: user }

          it 'return success flash and correct redirect' do
            expect(course.feedbacks.first.body).to eq(body)
            expect(course.feedbacks.first.grade).to eq(grade)
            expect(flash[:notice]).to eq(notice)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(promo_course_path(course))
          end
        end

        context 'when feedback is not exists' do

        end
      end

      context 'when not enroled' do

      end

      context 'when author' do
        let(:course) { create :course, author: user }

      end
    end

    context 'when not sign in' do

    end
  end

end
