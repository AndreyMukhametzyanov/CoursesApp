# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :set_course

  def create
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @feedback = @course.feedbacks.create(feedback_params)

      @feedback.save ?
        redirect_with_notice(promo_course_path(@course), I18n.t('feedbacks.create.success')) :
        redirect_with_alert(promo_course_path(@course), I18n.t('feedbacks.create.error'))
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.courses.enrolled_error'))
    end
  end

  def edit
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @feedback = Feedback.find_by(user: current_user, course: @course)
    else
      redirect_with_alert(courses_path, I18n.t('errors.courses.enrolled_error'))
    end
  end

  def update
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @feedback = Feedback.find_by(user: current_user, course: @course)
      if @feedback.update(feedback_params)
        redirect_with_notice(promo_course_path(@course), I18n.t('feedbacks.update.success'))
      else
        redirect_with_alert(promo_course_path(@course), I18n.t('feedbacks.update.error'))
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.courses.enrolled_error'))
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:body, :grade).merge(user: current_user)
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end
