# frozen_string_literal: true

class ExamsController < ApplicationController
  def new
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      if @course.exam.nil?
        @exam = @course.build_exam
      else
        redirect_to edit_course_exam_path(@course)
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.change_error'))
    end
  end

  def create
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @exam = @course.create_exam(permit_params(:exam, :title, :description, :attempts_count,
                                                :attempt_time,
                                                questions_attributes: [:id, :title, :_destroy,
                                                                       { answers_attributes:
                                                                           %i[id body correct_answer _destroy] }]))
      if @exam.save
        redirect_with_notice(promo_course_path(@course), I18n.t('exam.create'))
      else
        render :new
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.change_error'))
    end
  end

  def update
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @exam = @course.exam
      if @exam.update(permit_params(:exam, :title, :description, :attempts_count,
                                    :attempt_time,
                                    questions_attributes: [:id, :title, :_destroy,
                                                           { answers_attributes:
                                                               %i[id body correct_answer _destroy] }]))

        redirect_with_notice(promo_course_path(@course), I18n.t('exam.update'))
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
      @examinations = Examination.where(user: current_user, exam: @exam).order(:created_at)
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.access_error'))
    end
  end

  def start
    @course = Course.find_by(id: params[:course_id])
    unless @course.enrolled_in_course?(current_user)
      return redirect_with_alert(promo_course_path, I18n.t('errors.courses.enrolled_error'))
    end

    if @course.exam
      @examination = Examination.create(user: current_user, exam: @course.exam, passage_time: @course.exam.attempt_time,
                                        number_of_questions: @course.exam.questions.count,
                                        current_question: @course.exam.questions.first,
                                        next_question: @course.exam.questions.second)
      redirect_to examination_path(@examination)
    else
      redirect_with_alert(promo_course_path, I18n.t('errors.lessons.access_error'))
    end
  end
end
