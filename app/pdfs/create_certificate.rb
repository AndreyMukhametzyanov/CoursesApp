# frozen_string_literal: true

class CreateCertificate < Prawn::Document
  BACKGROUND_PATH = Rails.root.join('app', 'assets', 'images', 'certificate.jpg')

  def initialize(date:, user_name:, course_name:, uniq_code:)
    super

    @date = date
    @course_name = course_name
    @user_name = user_name
    @uniq_code = uniq_code

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

      text_box @user_name,
               at: [0, 385],
               align: :center,
               size: 36,
               style: :bold

      text_box "successfully completed course \n " "#{@course_name}",
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
