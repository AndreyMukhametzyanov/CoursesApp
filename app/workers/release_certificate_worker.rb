# frozen_string_literal: true

class ReleaseCertificateWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  UNIQ_CODE_LENGTH = 50

  def perform(order_id)
    order = Order.find(order_id)

    uniq_code = SecureRandom.alphanumeric(UNIQ_CODE_LENGTH)

    if order
      logger.info 'Create certificate start'
      logger.info "#{Order.all.inspect}"

      pdf = CreateCertificate.new(date: Date.today.strftime('%d.%m.%Y'),
                                  user_name: order.user.first_name,
                                  course_name: order.course.name,
                                  uniq_code: uniq_code).render

      certificate = order.build_certificate
      certificate.pdf.attach(io: StringIO.new(pdf), filename: "order:#{order.id}_certificate.pdf")
      certificate.uniq_code = uniq_code
      order.save

      logger.info 'Certificate successfully created'
    else
      logger.error("There is no orders with #{order_id} exists!")
    end
  end
end
