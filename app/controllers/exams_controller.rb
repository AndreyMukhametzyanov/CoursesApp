# frozen_string_literal: true

class ExamsController < ApplicationController
  before_action :set_course

  def show
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @exam = @course.exam
      @examinations = Examination.where(user: current_user, exam: @exam).order(:created_at)
      @not_finished_exam = Examination.where(user: current_user, exam: @exam, finished_exam: false).first
      @full_finished_exam = Examination.find_by(user: current_user, exam: @exam, finished_exam: true,
                                                percentage_passing: 100)
      @user_attempts = Examination.where(user: current_user, exam: @exam).count
      @attempts_of_exam = @exam.attempts_count

      max_percentage_passing = Examination.where(user: current_user, exam: @exam, passed_exam: true)
                                          .maximum(:percentage_passing)
      max_percentage_passing = -1 if max_percentage_passing.nil?

      Rails.logger.debug max_percentage_passing.class.inspect

      @examinations2 = Examination.where(user: current_user, exam: @exam)
                                  .select(
                                    '*',
                                    "case
                                          when percentage_passing = #{max_percentage_passing} then 'table-success'
                                          when passed_exam = true then 'table-info'
                                     else 'table-danger'
                                     end as row_color"
                                  ).order('percentage_passing')

    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.access_error'))
    end
  end

  def new
    if @course.owner?(current_user)
      return redirect_to(edit_course_exam_path(@course)) if @course.exam.present?

      @exam = @course.build_exam
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.change_error'))
    end
  end

  def edit
    if @course.owner?(current_user)
      @exam = @course.exam
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.change_error'))
    end
  end

  def create
    if @course.owner?(current_user)
      @exam = @course.create_exam(exam_params)

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
    if @course.owner?(current_user)
      @exam = @course.exam
      if @exam.update(exam_params)
        redirect_with_notice(promo_course_path(@course), I18n.t('exam.update'))
      else
        render :edit
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.change_error'))
    end
  end

  def start
    return redirect_with_alert(promo_course_path(@course), I18n.t('errors.exam.not_create')) unless @course.exam

    if @course.owner?(current_user)
      lesson = @course.lessons.first
      return redirect_with_alert(course_lesson_path(@course, lesson), I18n.t('errors.examination.start_error'))
    end

    unless @course.enrolled_in_course?(current_user)
      return redirect_with_alert(promo_course_path(@course), I18n.t('errors.courses.enrolled_error'))
    end

    return head :bad_request if Examination.where(user: current_user, exam: @course.exam, finished_exam: false).any?

    if Examination.where(user: current_user,
                         exam: @course.exam).count >= @course.exam.attempts_count
      redirect_with_alert(course_exam_path(@course.exam), I18n.t('errors.exam.attempt_error'))
    elsif @course.exam
      @examination = Examination.create(
        user: current_user,
        exam: @course.exam,
        passage_time: @course.exam.attempt_time,
        number_of_questions: @course.exam.questions.count,
        current_question: @course.exam.questions.first,
        next_question: @course.exam.questions.second
      )
      redirect_to examination_path(@examination)
    end
  end

  private

  def exam_params
    permit_params(
      :exam, :title, :description, :attempts_count, :attempt_time,
      questions_attributes: [
        :id, :title, :_destroy,
        { answers_attributes: %i[id body correct_answer _destroy] }
      ]
    )
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end
