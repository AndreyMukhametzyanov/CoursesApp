# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :set_course
  before_action :check_enroll

  def create
    @feedback = @course.feedbacks.create(feedback_params)

    if @feedback.save
      redirect_with_notice(promo_course_path(@course), I18n.t('feedbacks.create.success'))
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('feedbacks.create.error'))
    end
  end

  def update
    @feedback = Feedback.find_by(user: current_user, course: @course)
    if @feedback.update(feedback_params)
      redirect_with_notice(promo_course_path(@course), I18n.t('feedbacks.update.success'))
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('feedbacks.update.error'))
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:body, :grade).merge(user: current_user)
  end

  def check_enroll
    unless @course.enrolled_in_course?(current_user)
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.courses.enrolled_error'))
    end
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end
