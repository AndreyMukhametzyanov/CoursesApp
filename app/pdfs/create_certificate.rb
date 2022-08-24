# frozen_string_literal: true

class CreateCertificate < Prawn::Document
  UNIQ_CODE_LENGTH = 50
  BACKGROUND_PATH = Rails.root.join('app', 'assets', 'images', 'certificate.jpg')

  def initialize(date:, order_id:)
    super
    @date = date
    @order = Order.find(order_id)
    @uniq_code = SecureRandom.alphanumeric(UNIQ_CODE_LENGTH)

    create_pdf
  end

  def create_pdf
    bounding_box([100, 730], width: 540, height: 730) do
      image BACKGROUND_PATH, width: 540, height: 730
      font 'Times-Roman'

      text_box 'Certificate',
               at: [0, 600],
               align: :center,
               size: 48,
               style: :bold

      text_box 'This certificate confirms that ',
               at: [0, 465],
               align: :center,
               size: 16,
               style: :bold

      text_box @order.user.first_name.to_s,
               at: [0, 385],
               align: :center,
               size: 36,
               style: :bold

      text_box "successfully completed #{} on the course \n " "#{@order.course.name}",
               at: [0, 285],
               align: :center,
               size: 16,
               style: :bold

      text_box @uniq_code,
               at: [0, 120],
               align: :center,
               size: 16,
               style: :bold

      text_box @date.to_s,
               at: [0, 80],
               align: :center,
               size: 16,
               style: :bold
      stroke_bounds
    end
  end
end
