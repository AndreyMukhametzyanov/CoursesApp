# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe LessonsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#new' do
    let!(:course) { create :course, user: user }

    before { get :new, params: { course_id: course.id } }

    it 'should be correct render form ' do
      expect(response).to have_http_status(200)
      expect(response).to render_template('new')
    end
  end

  describe '#create' do
    let!(:course) { create :course, user: user }

    context 'when lesson is valid' do
      let!(:title) { 'Lesson' }
      let!(:content) { 'test' }
      # let!(:one_lesson) { course.lessons.last }

      it 'should render correct page' do
        post :create, params: { course_id: course.id, lesson: { title: 'Lesson', youtube_video_id: '',
                                                                content: 'test',
                                                                order_factor: 1 } }

        # expect(course.name).to eq(name)
        # expect(course.description).to eq(description)
        # expect(course.level).to eq(level)
        expect(response).to have_http_status(302)
        # expect(response).to redirect_to(course_lesson_path)
      end
    end

  end

  describe '#show' do

  end

  describe '#edit' do
  end

  describe '#update' do
  end
end
