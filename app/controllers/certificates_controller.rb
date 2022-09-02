class CertificatesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[check_certificate]
  layout 'check_certificate', :only => :check_certificate

  def index
    @orders_by_user = Order.where(user_id: current_user.id)
    if @orders_by_user
      @certificate = Certificate.find_by(uniq_code: params[:code])
    else
      redirect_with_alert(root_path, 'Сертификаты не найдены')
    end
  end

  def check_certificate
    @certificate = Certificate.find_by(uniq_code: params[:code])
  end

  private

  def certificate_params
    permit_params(:certificate, :uniq_code)
  end
end
