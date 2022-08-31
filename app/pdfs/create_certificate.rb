# frozen_string_literal: true
require "rqrcode"

class CreateCertificate < Prawn::Document
  BACKGROUND_PATH = Rails.root.join('app', 'assets', 'images', 'certificate.jpg')
  FONT_WALSHEIM_PATH = Rails.root.join('app', 'assets', 'fonts', 'GT-WalsheimPro.ttf')

  def initialize(date:, user_name:, course_name:, uniq_code:)
    super

    @date = date
    @course_name = course_name
    @user_name = user_name
    @uniq_code = uniq_code

    create_pdf
  end

  def create_pdf
    # stroke_axis

    bounding_box([0, 740], width: 540, height: 730) do

      image BACKGROUND_PATH, width: 540, height: 730
      text_box 'Certificate',
               at: [0, 600],
               align: :center,
               size: 48,
               style: :bold,
               font: FONT_WALSHEIM_PATH

      text_box 'This certificate confirms that ',
               at: [0, 465],
               align: :center,
               size: 16,
               style: :bold,
               font: FONT_WALSHEIM_PATH

      text_box @user_name,
               at: [0, 385],
               align: :center,
               size: 36,
               style: :bold,
               font: FONT_WALSHEIM_PATH

      text_box "successfully completed course \n " "#{@course_name}",
               at: [0, 285],
               align: :center,
               size: 16,
               style: :bold,
               font: FONT_WALSHEIM_PATH

      svg create_qr, width: 70, height: 70, at: [235, 180]

      text_box @date.to_s,
               at: [0, 80],
               align: :center,
               size: 12,
               style: :bold,
               font: FONT_WALSHEIM_PATH
    end
  end

  private

  def create_qr
    qrcode = RQRCode::QRCode.new("http://github.com/")

    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end
end
