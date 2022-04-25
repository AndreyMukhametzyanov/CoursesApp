class ExamsController < ApplicationController
  def new
    @course = Course.find_by(id: params[:course_id])
    if @course.exam.nil?
      @exam = @course.build_exam
    else
      redirect_to edit_course_exam_path(@course)
    end
  end

  def create
    @course = Course.find_by(id: params[:course_id])
    @exam = @course.create_exam(permit_params(:exam, :title, :description, :attempts_number,
                                              :attempts_time,
                                              questions_attributes: [:id,:title,:_destroy,
                                              answers_attributes: %i[id body _destroy]]))
    if @exam.save
      redirect_to promo_course_path(@course)
    else
      render :new
    end
  end

  def update
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @exam = @course.exam
      if @exam.update(permit_params(:exam, :title, :description, :attempts_number,
                                    :attempts_time,
                                    questions_attributes: [:id,:title,:_destroy,
                                    answers_attributes: %i[id body _destroy]]))
        redirect_to promo_course_path(@course)
      else
        render :edit
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.change_error'))
    end
  end

  def edit
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @exam = @course.exam
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.change_error'))
    end
  end

  def show
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @exam = @course.exam
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.access_error'))
    end
  end
end
