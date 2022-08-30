class CertificatesController < ApplicationController
  def index
    order = Order.find_by(user_id: current_user.id)
    @certificate = Certificate.find_by(order_id: order.id)
  end

  def find

  end
end