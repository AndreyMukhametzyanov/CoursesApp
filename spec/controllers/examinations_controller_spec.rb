# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ExaminationsController, type: :controller do
  let!(:user) { create(:user) }
  let(:examination) do
    Examination.create(user: user, exam: exam, passage_time: exam.attempt_time, number_of_questions: exam.questions.count,
                       current_question: exam.questions.first, next_question: exam.questions.second)
  end
  let!(:course) { create :course, author: user }
  let(:exam) do
    Exam.create(course: course, title: 'MyExam', description: 'Text', attempts_count: 1, attempt_time: 120,
                questions_attributes: questions)
  end
  let(:answers) { [{ body: 'yes', correct_answer: true }, { body: 'no', correct_answer: false }] }
  let(:another_answers) { [{ body: 'yes', correct_answer: false }, { body: 'no', correct_answer: true }] }
  let(:questions) do
    [{ title: 'First?', answers_attributes: answers },
     { title: 'Second?', answers_attributes: another_answers }]
  end

  before { sign_in user }

  describe '#show' do

    before do
      get :show, params: { id: examination.id }
    end

    context 'when examination still in progress' do
      it 'return correct examination form with questions and answers' do
        puts examination.inspect
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('show')
      end
    end

    context 'when examination was finished' do
      let(:examination) do
        Examination.create(user: user, exam: exam, passage_time: exam.attempt_time,
                           number_of_questions: exam.questions.count,
                           current_question: exam.questions.first, finished_exam: true,
                           next_question: exam.questions.second)
      end

      it 'return correct examination form with questions and answers' do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to course_exam_path(examination.exam.course)
      end
    end

    context 'when examination was successfully finished' do
      let(:examination) do
        Examination.create(user: user, exam: exam, passage_time: exam.attempt_time,
                           number_of_questions: exam.questions.count,
                           current_question: exam.questions.first, finished_exam: true, passed_exam: true,
                           next_question: exam.questions.second)
      end

      it 'return correct examination form with questions and answers' do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to course_exam_path(examination.exam.course)
      end
    end

  end

  describe '#check_answer' do

    context 'when the student answered correctly and time is over' do
      let(:correct_answer) { exam.questions.first.answers.where(correct_answer: true).ids }

      before do
        post :check_answer, params: { id: examination.id, user_answers: { current_question: correct_answer } }
      end

      it 'return' do
        puts examination.reload.inspect
      end
    end
  end
end
