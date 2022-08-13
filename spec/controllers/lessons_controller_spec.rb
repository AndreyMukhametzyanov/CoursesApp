# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe LessonsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#new' do
    context 'when user not owner of course' do
      let!(:course) { create :course, author: user }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :new, params: { course_id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end

    context 'when user is owner of course' do
      let!(:course) { create :course, author: user }

      before { get :new, params: { course_id: course.id } }

      it 'is correct render form' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('new')
      end
    end
  end

  describe '#create' do
    context 'when user is owner' do
      let!(:course) { create :course, author: user }

      context 'when lesson is valid' do
        let!(:title) { 'Lesson' }
        let!(:content) { "<div class=\"trix-content\">\n  test\n</div>\n" }
        let(:one_lesson) { course.lessons.last }
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.txt')) }
        let(:another_file) do
          Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/course_cover_picture.png'))
        end

        let(:links) { [{ address: 'https://www.google.com/' }, { address: 'https://www.ya.ru/' }] }

        before do
          post :create, params: { course_id: course.id, lesson: { title: 'Lesson', youtube_video_id: '',
                                                                  content: 'test', order_factor: 1,
                                                                  files: [file, another_file],
                                                                  links_attributes: links } }
        end

        it 'renders correct page' do
          expect(one_lesson.links.count).to eq(links.count)
          expect(one_lesson.title).to eq(title)
          expect(one_lesson.content.to_s).to eq(content)
          expect(one_lesson.files).to be_attached
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(course_lesson_path(course, one_lesson))
        end
      end

      context 'when lesson is not valid' do
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before { post :create, params: { course_id: course.id, lesson: { title: '' } } }

        it 'returns errors' do
          expect(assigns(:lesson).errors[:title].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('new')
        end
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, author: user }
      let(:new_user) { create :user }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }

      before do
        sign_in new_user
        post :create, params: { course_id: course.id, lesson: { title: 'Lesson', youtube_video_id: '',
                                                                content: 'test',
                                                                order_factor: 1 } }
      end

      it 'returns errors' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#show' do
    let!(:course) { create :course, author: user }
    let!(:lesson) { create :lesson, course: course }

    context 'when user is enrolled in course' do
      before do
        create :order, user: user, course: course
        get :show, params: { course_id: course.id, id: lesson.id }
      end

      it 'return correct render' do
        expect(assigns(:lesson)).to eq(lesson)
        expect(assigns(:course)).to eq(course)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('show')
      end
    end

    context 'when user is not enrolled in course' do
      let(:new_user) { create :user }
      let(:error_msg) { I18n.t 'errors.lessons.access_error' }

      before do
        sign_in new_user
        get :show, params: { course_id: course.id, id: lesson.id }
      end

      it 'return correct render' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#edit' do
    context 'when user is owner' do
      let!(:course) { create :course, author: user }
      let!(:lesson) { create :lesson, course: course }

      before { get :edit, params: { course_id: course.id, id: lesson.id } }

      it 'is correct render form' do
        expect(assigns(:course)).to eq(course)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('edit')
      end
    end

    context 'when user is not owner' do
      let!(:course) { create :course, author: user }
      let!(:lesson) { create :lesson, course: course }
      let(:alert_message) { I18n.t('errors.lessons.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :edit, params: { course_id: course.id, id: lesson.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#update' do
    context 'when user is owner' do
      context 'when data is correct' do
        let(:new_title) { 'new lesson' }
        let!(:course) { create :course, author: user }
        let!(:lesson) { create :lesson, course: course }

        before { patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } } }

        it 'updates course and check redirect to root' do
          expect(assigns(:lesson).title).to eq(new_title)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(course_lesson_path(course, lesson))
        end
      end

      context 'when data does not correct' do
        let(:new_title) { '' }
        let!(:course) { create :course, author: user }
        let!(:lesson) { create :lesson, course: course }
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before { patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } } }

        it 'returns error' do
          expect(assigns(:lesson).errors[:title].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('edit')
        end
      end

      context 'when user is not owner' do
        let!(:course) { create :course, author: user }
        let!(:lesson) { create :lesson, course: course }
        let(:new_user) { create :user }
        let(:alert_message) { I18n.t('errors.lessons.change_error') }
        let(:new_title) { '' }

        before do
          sign_in new_user
          patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: new_title } }
        end

        it 'returns errors' do
          expect(flash[:alert]).to eq(alert_message)
          expect(response).to redirect_to promo_course_path(course)
        end
      end
    end
  end

  describe '#complete' do
    let(:student) { create :user }
    let!(:course) { create :course, author: user }
    let!(:lesson) { create :lesson, course: course }
    let(:final_project) do
      FinalProject.create(course_id: course.id, description: 'test', short_description: 'test', execution_days: 10)
    end
    let(:exam) do
      Exam.create(title: 'test', description: 'test', attempts_count: 12, attempt_time: 120, course_id: course.id)
    end
    let(:create_order) do
      Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                              completed_lessons_ids: [],
                                                              project_complete: false,
                                                              exam_complete: false })
    end

    let(:order) { Order.find_by(user_id: student.id, course: course) }

    before { sign_in student }

    context 'when complete lesson not include in completed_lessons_ids' do
      let(:create_order) do
        Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                                completed_lessons_ids: [],
                                                                project_complete: false,
                                                                exam_complete: false })
      end
      let(:order) { Order.find_by(user_id: student.id, course: course) }

      before do
        create_order
        post :complete, params: { course_id: course.id, id: lesson.id }
      end

      it 'add lesson id in completed_lessons_ids' do
        expect(order.completed_lessons_ids.first).to eq(lesson.id)
      end
    end

    context 'when next lesson is empty' do
      context 'when final project exist' do
        before do
          final_project
          create_order
          post :complete, params: { course_id: course.id, id: lesson.id }
        end

        it 'redirect to final project page' do
          expect(response).to redirect_to(course_final_project_path(course))
        end
      end

      context 'when exam exist' do
        before do
          exam
          create_order
          post :complete, params: { course_id: course.id, id: lesson.id }
        end

        it 'redirect to exam page' do
          expect(response).to redirect_to(course_exam_path(course))
        end
      end

      context 'when final project or exam is not exist' do
        let(:notice) { I18n.t('lessons.lessons_all_end') }
        let(:create_order) do
          Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                                  completed_lessons_ids: [] })
        end

        before do
          create_order
          post :complete, params: { course_id: course.id, id: lesson.id }
        end

        it 'redirect to promo page with notice' do
          expect(flash[:notice]).to eq(notice)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end
    end

    context 'when next lesson is not empty' do
      let(:next_lesson) { course.lessons.where('order_factor > ?', lesson.order_factor) }
      let(:new_lesson) { create :lesson, course: course }
      let(:create_order) do
        Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                                completed_lessons_ids: [] })
      end

      before do
        new_lesson
        create_order
        post :complete, params: { course_id: course.id, id: lesson.id }
      end

      it 'redirect to next lesson page' do
        expect(response).to redirect_to(course_lesson_path(course, next_lesson.first&.id))
      end
    end
  end
end
