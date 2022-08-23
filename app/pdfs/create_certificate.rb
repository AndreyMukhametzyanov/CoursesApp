# frozen_string_literal: true

class CreateCertificate < Prawn::Document
  def initialize(date:, user_course:, course_part:, student_name:)
    super
    @date = date
    @user_course = user_course
    @course_part = course_part
    @student_name = student_name

    create_pdf
  end

  def create_pdf
    bounding_box([100, 730], width: 540, height: 730) do
      image "#{__dir__}/app/pdfs/images/certificate.jpg", width: 540, height: 730
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

      text_box @student_name.to_s,
               at: [0, 385],
               align: :center,
               size: 36,
               style: :bold

      text_box "successfully completed #{@course_part} on the course \n " "#{@user_course}",
               at: [0, 285],
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
