# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe ReleaseCertificateWorker, type: :worker do
  let!(:user) { create(:user) }
  let!(:student) { create(:user) }
  let!(:course) { create :course, author: user, lessons: [(create :lesson)] }
  let!(:order) do
    Order.create(user: student, course: course, progress: { total_lessons: course.lessons.count,
                                                            completed_lessons_ids: [course.lessons.first&.id],
                                                            project_complete: false,
                                                            exam_complete: false })
  end
  let(:job) { described_class.perform_at(10.seconds, order.id) }

  it 'should ' do
    Sidekiq::Testing.inline! do
      job
    end
    puts Certificate.last
    # assert_equal true, described_class.jobs.last['jid'].include?(job)
    # expect(described_class).to have_enqueued_sidekiq_job(id)
  end
end