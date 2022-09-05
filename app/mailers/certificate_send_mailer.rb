# frozen_string_literal: true

class CertificateSendMailer < ApplicationMailer
  def send_certificate
    @user = params[:user]
    @order = params[:order]
    @certificate = Certificate.find_by(order: @order)

    attachments["order-#{@order.id}_certificate.pdf"] = {
      mime_type: @certificate.pdf.blob.content_type,
      content: @certificate.pdf.blob.download }

    mail to: @user.email,
         subject: I18n.t('certificate.subject')
  end
end
