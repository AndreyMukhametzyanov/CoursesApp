# frozen_string_literal: true

class ReleaseCertificateWorker
  include Sidekiq::Worker

  def perform(*_args)
    # CreateCertificate.new(date: Date.today.strftime('%d.%m.%Y'), ).render
  end
end