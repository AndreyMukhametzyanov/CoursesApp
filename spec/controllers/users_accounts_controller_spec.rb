# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersAccountsController do
  let(:student) { create(:user) }
  let(:user) { create(:user) }
  let!(:course) { create(:course, author: user, create_certificate: true, lessons: [create(:lesson)]) }
  let(:exam) { create(:exam, course: course) }
  let(:examination) { create(:examination, exam: exam) }
  let(:student_order) do
    Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                            completed_lessons_ids: [course.lessons.first&.id],
                                                            project_complete: true,
                                                            exam_complete: true })
  end

  describe '#created_courses' do
    context 'when user is teacher' do
      before do
        course
        sign_in user
        get :created_courses
      end

      it 'returns correct renders for #index' do
        expect(response).to have_http_status(:ok)
        expect(assigns(:courses).first.author).to eq(user)
        expect(response).to render_template('created_courses')
      end
    end
  end

  describe '#certificates' do
    context 'when user have certificates' do
      let(:certificate) { create(:certificate, order: student_order) }
      let(:result) { Certificate.find_by(uniq_code: certificate.uniq_code).uniq_code }

      before do
        certificate
        sign_in student
        get :certificates
      end

      it 'return certificates' do
        expect(response).to have_http_status(:ok)
        expect(certificate.order.user.id).to eq(student.id)
        expect(response).to render_template('certificates')
      end
    end
  end

  describe '#studied_courses' do
    context 'when student have orders' do
      before do
        sign_in student
        get 'studied_courses'
      end

      it 'render all student courses' do
        expect(response).to have_http_status(:ok)
        expect(assigns(:studied_courses)).to eq(student.orders)
        expect(response).to render_template('studied_courses')
      end
    end
  end

  describe '#students_reply' do
    let(:final_project) { create(:final_project, course: course) }
    let(:user_project) { create(:user_project, final_project: final_project, user: student) }
    let(:reply) { create(:reply, user_project: user_project) }

    before do
      sign_in user
      reply
      get 'students_reply'
    end

    it 'returns student replies' do
      expect(response).to have_http_status(:ok)
      expect(assigns(:replies).first.user_project.id).to eq(student.user_projects.first.id)
      expect(response).to render_template('students_reply')
    end
  end
end
