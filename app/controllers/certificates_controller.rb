class CertificatesController < ApplicationController
  def index
    order = Order.find_by(user_id: current_user.id)
    @certificates = Certificate.where(order_id: order.id)
  end

  def find

  end
end