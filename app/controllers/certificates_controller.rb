class CertificatesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[check_certificate]

  def index
    order = Order.find_by(user_id: current_user.id)
    if order
      @certificate = Certificate.find_by(order_id: order.id)
    else
      redirect_with_alert(root_path, 'NET')
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
