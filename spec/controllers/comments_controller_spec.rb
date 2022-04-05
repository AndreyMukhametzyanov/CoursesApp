# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#create' do
    let!(:course) { create :course, user: user }

    context 'when the comment for course is valid' do
      let(:new_comment) { 'test' }
      let(:comment) { course.comments.last }
      let(:notice) { I18n.t 'comments.create.success' }
      before { post :create, params: { course_id: course.id, comment: { body: new_comment } } }

      it 'should return success notice and redirect to correct page' do
        expect(comment.body).to eq(new_comment)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(promo_course_path(id: course.id))
      end
    end

    context 'when the comment for lesson is valid' do
      let!(:lesson) { create :lesson, course: course }
      let(:new_body) { 'test' }
      let(:one_comment) { course.lessons.last.comments.last }
      let(:notice) { I18n.t 'comments.create.success' }

      before { post :create, params: { course_id: course.id, lesson_id: lesson.id, comment: { body: new_body } } }

      it 'should return success notice and redirect to correct page' do
        expect(one_comment.body).to eq(new_body)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq(notice)
        expect(response).to redirect_to(course_lesson_path(course_id: course.id, id: lesson.id))
      end
    end

    context 'when the comment for course is not valid' do
      let(:new_comment) { 't' }
      let(:comments) { course.comments }
      let(:error) { I18n.t 'comments.create.error' }
      before { post :create, params: { course_id: course.id, comment: { body: new_comment } } }

      it 'should return success notice and redirect to correct page' do
        expect(comments.count).to eq(0)
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq(error)
        expect(response).to redirect_to(promo_course_path(id: course.id))
      end
    end

    context 'when the comment for lesson is not valid' do
      let!(:lesson) { create :lesson, course: course }
      let(:new_body) { 't' }
      let(:comments) { course.lessons.last.comments }
      let(:error) { I18n.t 'comments.create.error' }

      before { post :create, params: { course_id: course.id, lesson_id: lesson.id, comment: { body: new_body } } }

      it 'should return success notice and redirect to correct page' do
        expect(comments.count).to eq(0)
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq(error)
        expect(response).to redirect_to(course_lesson_path(course_id: course.id, id: lesson.id))
      end
    end
  end
end
