# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ExamsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  describe '#new' do
    let!(:course) { create :course, author: user }

    context 'when user is owner' do
      before { get :new, params: { course_id: course.id } }

      it 'is correct render form' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('new')
      end
    end

    context 'when user not owner' do
      let(:alert_message) { I18n.t('errors.exam.change_error') }
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
  end

  describe '#create' do
    let!(:course) { create :course, author: user }

    context 'when user is owner' do
      context 'when new exam is valid' do
        let(:title) { 'MyExam' }
        let(:description) { 'Text' }
        let(:attempts_count) { 1 }
        let(:attempt_time) { 120 }
        let(:answers) { [{ body: 'yes', correct_answer: true }, { body: 'no', correct_answer: false }] }
        let(:another_answers) { [{ body: 'yes', correct_answer: false }, { body: 'no', correct_answer: true }] }
        let(:questions) do
          [{ title: 'First?', answers_attributes: answers },
           { title: 'Second?', answers_attributes: another_answers }]
        end
        let(:notice) { I18n.t('exam.create') }

        before do
          post :create, params: { course_id: course.id, exam: { title: 'MyExam', description: 'Text',
                                                                attempts_count: 1, attempt_time: 120,
                                                                questions_attributes: questions } }
        end

        it 'is create exam and render correct page' do
          expect(course.exam).to be_valid
          expect(course.exam.title).to eq(title)
          expect(course.exam.description).to eq(description)
          expect(course.exam.attempts_count).to eq(1)
          expect(course.exam.attempt_time).to eq(120)
          expect(course.exam.questions.count).to eq(2)
          expect(course.exam.questions.first.title).to eq(questions.first[:title])
          expect(course.exam.questions.first.answers.first.body).to eq(answers.first[:body])
          expect(course.exam.questions.first.answers.first.correct_answer).to be_truthy
          expect(course.exam.questions.first.answers.last.body).to eq(answers.last[:body])
          expect(course.exam.questions.last.answers.first.correct_answer).to be_falsey
          expect(flash[:notice]).to eq(notice)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end

      context 'when new exam is not valid' do
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before do
          post :create, params: { course_id: course.id, exam: { title: '' } }
        end

        it 'returns errors' do
          expect(assigns(:exam).errors[:title].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('new')
        end
      end
    end

    context 'when user not is owner' do
      let(:alert_message) { I18n.t('errors.exam.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        post :create, params: { course_id: course.id, exam: { title: 'MyExam', description: 'Text',
                                                              attempts_number: 1, attempts_time: 120 } }
      end

      it 'returns errors' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#update' do
    let!(:course) { create :course, author: user }
    let!(:exam) { create :exam, course: course }

    context 'when user is owner' do
      context 'when data is correct' do
        let(:new_title) { 'NewTitle' }
        let(:notice) { I18n.t('exam.update') }

        before do
          patch :update, params: { course_id: course.id, exam: { title: new_title } }
        end

        it 'updates exam and check redirect to promo' do
          expect(exam.reload.title).to eq(new_title)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(promo_course_path(course))
        end
      end

      context 'when data is not correct' do
        let(:new_title) { '' }
        let(:error_msg) { I18n.t('errors.lessons.blank_error') }

        before do
          patch :update, params: { course_id: course.id, exam: { title: new_title } }
        end

        it 'returns error' do
          expect(assigns(:exam).errors[:title].first).to eq(error_msg)
          expect(response).to have_http_status(:ok)
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when user is not owner' do
      let(:new_user) { create :user }
      let(:alert_message) { I18n.t('errors.exam.change_error') }
      let(:new_title) { 'NewTitle' }

      before do
        sign_in new_user
        patch :update, params: { course_id: course.id, exam: { title: new_title } }
      end

      it 'returns errors' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#edit' do
    let!(:course) { create :course, author: user }

    context 'when user is owner' do
      let!(:exam) { create :exam, course: course }

      before do
        get :edit, params: { course_id: course.id }
      end

      it 'is correct render form' do
        expect(assigns(:exam)).to eq(exam)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('edit')
      end
    end

    context 'when user is not owner' do
      let(:error_msg) { I18n.t('errors.exam.change_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :edit, params: { course_id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#show' do
    let!(:course) { create :course, author: user }
    let!(:exam) { create :exam, course: course }

    context 'when user is owner or user is enrolled in course' do
      before do
        get :show, params: { course_id: course.id }
      end

      it 'return correct render' do
        expect(assigns(:exam)).to eq(exam)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('show')
      end
    end

    context 'when user is not owner or is not enrolled in course' do
      let(:error_msg) { I18n.t('errors.exam.access_error') }
      let(:new_user) { create :user }

      before do
        sign_in new_user
        get :show, params: { course_id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to promo_course_path(course)
      end
    end
  end

  describe '#start' do
    let!(:course) { create :course, author: user }
    let!(:lesson) { create :lesson, course: course }
    let(:exam) { create :exam, course: course }

    context 'when user is owner' do
      let(:error_msg) { I18n.t 'errors.examination.start_error' }

      before do
        exam
        post :start, params: { course_id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to course_lesson_path(course, lesson)
      end
    end

    context 'when user is not enrolled in course' do
      let(:error_msg) { I18n.t('errors.courses.enrolled_error') }
      let(:new_user) { create :user }

      before do
        exam
        sign_in new_user
        post :start, params: { course_id: course.id }
      end

      it 'returns alert and correct redirect' do
        expect(flash[:alert]).to eq(error_msg)
        expect(response).to redirect_to promo_course_path(course)
      end
    end

    context 'when examination exists and not finished' do
      let(:student) { create :user }
      let!(:examination) { create :examination, exam: exam, user: student }
      let(:student_order) do
        Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                                completed_lessons_ids: [],
                                                                project_complete: false,
                                                                exam_complete: false })
      end

      before do
        sign_in student
        student_order
        post :start, params: { course_id: course.id }
      end

      it 'return bad request error' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when start examination' do
      let(:student) { create :user }
      let(:student_order) do
        Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                                completed_lessons_ids: [],
                                                                project_complete: false,
                                                                exam_complete: false })
      end

      describe 'when the number of attempts is exceeded' do
        let!(:examination) { create :examination, exam: exam, user: student,  finished_exam: true }
        let(:error_msg) { I18n.t('errors.exam.attempt_error') }

        before do
          sign_in student
          student_order
          post :start, params: { course_id: course.id }
        end

        it 'return alert and correct redirect' do
          expect(flash[:alert]).to eq(error_msg)
          expect(response).to redirect_to course_exam_path(exam)
        end
      end

      describe 'when everything ok' do
        let!(:exam) { create :exam, course: course }
        let(:examination) { Examination.find_by(exam: exam) }

        before do
          sign_in student
          student_order
          post :start, params: { course_id: course.id }
        end

        it 'returns alert and correct redirect' do
          expect(assigns(:examination)).to eq(examination)
          expect(response).to redirect_to examination_path(examination)
        end

      end

      describe 'when exam is not create' do
        let(:error_msg) { I18n.t('errors.exam.not_create') }

        before do
          sign_in student
          student_order
          post :start, params: { course_id: course.id }
        end

        it 'returns alert and correct redirect' do
          expect(flash[:alert]).to eq(error_msg)
          expect(response).to redirect_to promo_course_path(course)
        end
      end

    end
  end
end
