# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ReleaseCertificateWorker, type: :worker do
  let!(:user) { create(:user) }
  let!(:student) { create(:user) }
  let!(:course) { create(:course, author: user, lessons: [create(:lesson)]) }
  let!(:order) do
    Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                            completed_lessons_ids: [course.lessons.first&.id],
                                                            project_complete: false,
                                                            exam_complete: false })
  end

  describe 'that have enqueued sidekiq job' do
    let(:job) { described_class.perform_at(time, order.id) }
    let(:time) { 10.seconds.from_now }

    it 'that have enqueued at time' do
      job
      expect(described_class).to have_enqueued_sidekiq_job(order.id).at(time)
    end
  end

  describe 'worker' do
    let(:job) { described_class.new.perform(order.id) }

    it 'return that certificate was create and pdf file was attached' do
      job
      expect(Certificate.all).not_to be_empty
      expect(Certificate.last.pdf).to be_attached
    end
  end
end
