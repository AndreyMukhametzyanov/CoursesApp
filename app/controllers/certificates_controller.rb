class CertificatesController < ApplicationController
  # before_action :authenticate_user!, except: %i[index check_certificate]

  def index
    order = Order.find_by(user_id: current_user.id)
    if order
      @certificate = Certificate.find_by(order_id: order.id)
    else
      redirect_with_alert(root_path,'NET')
    end
  end

  def check_certificate

  end
end