# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe CertificatesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:student) { create(:user) }
  let!(:course) { create :course, author: user, lessons: [(create :lesson)] }
  let(:exam) { create :exam, course: course }
  let(:examination) { create :examination, exam: exam }
  let(:student_order) do
    Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                            completed_lessons_ids: [course.lessons.first&.id],
                                                            project_complete: false,
                                                            exam_complete: false })
  end

  describe '#index' do
    context 'when user orders is nil' do
      let(:alert_message) { I18n.t('errors.courses.enrolled_error') }

      before do
        sign_in student
        get :index
      end

      it 'return error and redirect to root' do
        expect(flash[:alert]).to eq(alert_message)
        expect(response).to redirect_to root_path
      end
    end

    context 'when user orders is not nil and find certificate' do

      before do
        sign_in student
        student_order
        get :index
      end

      it 'find certificate' do
        puts Certificate.all
      end
    end
  end

  describe '#check_certificate' do

  end
end