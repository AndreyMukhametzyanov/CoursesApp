# frozen_string_literal: true

class CertificatesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[check_certificate]
  layout 'check_certificate', only: :check_certificate

  def index
    @current_user_orders = Order.where(user_id: current_user.id)
    redirect_with_alert(root_path, I18n.t('errors.courses.enrolled_error')) if @current_user_orders.empty?
  end

  def check_certificate
    @certificate = Certificate.find_by(uniq_code: params[:code])
  end
end
