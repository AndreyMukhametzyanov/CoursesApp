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
        expect(response).to have_http_status(200)
        expect(response).to render_template('courses/index')
      end
    end

    context 'when new course is not create' do

    end

  end

  describe '#edit' do
  end

  describe '#update' do
  end

  describe '#promo' do
  end

  describe '#start' do
  end
end
