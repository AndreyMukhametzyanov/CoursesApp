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
      before do
        sign_in student
        get :index
      end

      it 'return error and redirect to root' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('index')
      end
    end
  end

  describe '#check_certificate' do
    let(:certificate) { create :certificate, order: student_order }
    let(:result) { Certificate.find_by(uniq_code: certificate.uniq_code).uniq_code }

    before { get :check_certificate }

    it 'return error and redirect to root' do
      expect(result).to eq(certificate.uniq_code)
    end
  end
end
