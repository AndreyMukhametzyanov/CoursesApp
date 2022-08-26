# frozen_string_literal: true

class ReleaseCertificateWorker
  include Sidekiq::Worker

  UNIQ_CODE_LENGTH = 50

  def perform(order_id)
    order = Order.find(order_id)
    uniq_code = SecureRandom.alphanumeric(UNIQ_CODE_LENGTH)

    if order
      logger.info 'Create certificate start'

      CreateCertificate.new(date: Date.today.strftime('%d.%m.%Y'),
                            course_part: 'final_project',
                            user_name: order.user.first_name,
                            course_name: order.course.name,
                            uniq_code: uniq_code).render

      logger.info 'Certificate successfully created'
    else
      order.errors.add(:order, "There is no orders with #{order_id} exists!")
    end
  end
end
