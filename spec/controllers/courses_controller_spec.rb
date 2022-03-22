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
    before { get :edit }
    it 'should returns correct renders for #edit' do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(courses_path)
    end
  end

  describe '#update' do
    let(:new_name) { "TEST" }
    let!(:course) { create :course, id: 1, user_id: user.id }

    before do
      post :update, params: { course: { user_id: user.id, name: new_name, video_link: '',
                                        description: 'test',
                                        level: 1 } }
    end

    it 'should update course and check redirect to root' do

      expect(Course.first.name).to eq(new_name)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#promo' do
    before { get :promo }
    it 'should returns correct renders for #edit' do

    end
  end

  describe '#start' do
  end
end
