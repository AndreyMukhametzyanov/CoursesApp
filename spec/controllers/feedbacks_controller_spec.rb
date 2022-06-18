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

    context 'when feedback was created' do
      before { post :create, params: { course_id: course.id, feedback: { body: body, grade: grade } } }

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
