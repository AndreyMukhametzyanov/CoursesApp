# frozen_string_literal: true

class CertificatesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[check_certificate]
  layout 'check_certificate', only: :check_certificate

  def index
    @certificates = current_user.certificates
  end

  def check_certificate
    @certificate = Certificate.find_by(uniq_code: params[:code])
  end
end
