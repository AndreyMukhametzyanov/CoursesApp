# frozen_string_literal: true
require 'rqrcode'

class CreateCertificate < Prawn::Document
  BACKGROUND_PATH = Rails.root.join('app', 'assets', 'images', 'certificate.jpg')

  def initialize(date:, user_name:, course_name:, path:, course_part:)
    super

    self.font_families.update('OpenSans' => {
      normal: Rails.root.join('app/assets/fonts/OpenSans/OpenSans-Regular.ttf'),
      italic: Rails.root.join('app/assets/fonts/OpenSans/OpenSans-Italic.ttf'),
      bold: Rails.root.join('app/assets/fonts/OpenSans/OpenSans-Bold.ttf'),
      bold_italic: Rails.root.join('app/assets/fonts/OpenSans/OpenSans-BoldItalic.ttf')
    })

    font 'OpenSans'

    @date = date
    @course_name = course_name
    @user_name = user_name
    @path = path
    @course_part = course_part

    create_pdf
  end

  def create_pdf
    stroke_axis

    bounding_box([0, 740], width: 540, height: 730) do

      image BACKGROUND_PATH, width: 540, height: 730
      text_box I18n.t('certificate.certificate'),
               at: [0, 600],
               align: :center,
               size: 48,
               style: :bold

      text_box "#{I18n.t('certificate.confirm')}\n #{I18n.t('certificate.finished', user: @user_name)}",
               at: [0, 465],
               align: :center,
               size: 16,
               style: :bold

      text_box @course_name,
               at: [0, 385],
               align: :center,
               size: 26,
               style: :bold

      text_box @course_part,
               at: [0, 285],
               align: :center,
               size: 16,
               style: :bold

      svg create_qr(@path), width: 70, height: 70, at: [235, 180]

      text_box @date.to_s,
               at: [0, 80],
               align: :center,
               size: 12,
               style: :bold
    end
  end

  private

  def create_qr(path)
    qrcode = RQRCode::QRCode.new(path)

    qrcode.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end
end
