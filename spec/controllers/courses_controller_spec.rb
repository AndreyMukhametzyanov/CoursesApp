# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe CoursesController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#index' do
    let!(:courses) { create_list :course, 3 }

    before { get :index }

    it 'should returns correct renders for #index' do
      expect(response).to have_http_status(200)
      expect(assigns(:courses)).to eq(courses)
      expect(response).to render_template('index')
    end
  end

  describe '#create' do
    context 'when new course is valid' do
      let(:name) { 'Course' }
      let(:description) { 'test' }
      let(:level) { 1 }

      it 'should render correct page' do
        post :create, params: { course: { user_id: user.id, name: 'Course', video_link: '',
                                          description: 'test',
                                          level: 1 } }

        expect(Course.last.name).to eq(name)
        expect(Course.last.description).to eq(description)
        expect(Course.last.level).to eq(level)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(courses_path)
      end
    end

    context 'when new course is not valid' do
      it 'should render new form' do
        post :create, params: { course: { user_id: user.id, name: 'Course', video_link: 'asdsa',
                                          description: 'test',
                                          level: 1 } }

        expect(Course.last).not_to be_a_new(Course)
        expect(response).to have_http_status(200)
        expect(response).to render_template('new')
      end
    end
  end

  describe '#edit' do
    let!(:course) { create :course, user: user }
    before { get :edit, params: { id: course.id } }

    it 'should returns correct renders for #edit' do
      expect(assigns(:course)).to eq(course)
      expect(response).to have_http_status(200)
      expect(response).to render_template('edit')
    end
  end

  describe '#update' do
    let(:new_name) { 'new name' }
    let!(:course) { create :course, user: user }

    before do
      patch :update, params: { id: course.id, course: { name: new_name } }
    end

    it 'should update course and check redirect to root' do
      expect(course.reload.name).to eq(new_name)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(courses_path)
    end
  end

  describe '#promo' do
    let!(:course) { create :course, user: user }
    before { get :promo, params: { id: course.id } }

    it 'should returns correct renders for #promo' do
      expect(assigns(:course)).to eq(course)
      expect(response).to have_http_status(200)
      expect(response).to render_template('promo')
    end
  end

  describe '#start' do
    let!(:course) { create :course, user: user }
    let!(:lesson) { create :lesson, course: course, order_factor: 1 }
    before { get :start, params: { id: course.id } }

    it 'should returns correct renders for #start' do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(course_lessons_path(course, lesson))
      #Expected "http://test.host/courses/144/lessons.26" to be === "http://test.host/courses/144/lessons/26".
      # откуда взялась точка?
    end
  end
end
