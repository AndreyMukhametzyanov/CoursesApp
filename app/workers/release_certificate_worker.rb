# frozen_string_literal: true

class ReleaseCertificateWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)

    CreateCertificate.new(date: Date.today.strftime('%d.%m.%Y'),
                          course_part: "final_project",
                          user_name: order.user.first_name,
                          course_name: order.course.name,
                          uniq_code: SecureRandom.alphanumeric(Order::UNIQ_CODE_LENGTH)).render
  end
end
