# frozen_string_literal: true

class ReleaseCertificateWorker
  include Sidekiq::Worker

  UNIQ_CODE_LENGTH = 50

  def perform(order_id)
    order = Order.find(order_id)

    uniq_code = SecureRandom.alphanumeric(UNIQ_CODE_LENGTH)

    uniq_code = SecureRandom.alphanumeric(UNIQ_CODE_LENGTH) until uniq_code?(uniq_code)

    if order
      logger.info "Create certificate start at #{Time.zone.today.strftime('%d.%m.%Y')}"
      path = Rails.application.routes.url_helpers.check_certificate_certificates_url(code: uniq_code)

      pdf = CreateCertificate.new(date: Time.zone.today.strftime('%d.%m.%Y'),
                                  user_name: order.user.first_name,
                                  course_name: order.course.name,
                                  path: path,
                                  course_part: order.check_part_of_course).render
      certificate = order.build_certificate
      certificate.pdf.attach(io: StringIO.new(pdf), filename: "order:#{order.id}_certificate.pdf")
      certificate.uniq_code = uniq_code
      order.save

      logger.info certificate.errors.inspect.to_s

      logger.info Certificate.all.inspect.to_s
      logger.info 'Certificate successfully created'

      CertificateSendMailer.with(user: order.user, order: order).send_certificate.deliver_later

      logger.info 'Certificate successfully sent to user email'
    else
      logger.error("There is no orders with #{order_id} exists!")
    end
  end

  private

  def uniq_code?(code)
    Certificate.where(uniq_code: code).empty?
  end
end
