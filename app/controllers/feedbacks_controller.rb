# frozen_string_literal: true

class FeedbacksController < ApplicationController
  def create
    course = Course.find_by(id: params[:course_id])
    @feedback = course.feedbacks.create(feedback_params)

    @feedback.save ? flash[:notice] = t('feedbacks.create.success') : flash[:alert] = t('feedbacks.create.error')
    redirect_to courses_path
  end

  def feedback_params
    params.require(:feedback).permit(:body, :grade).merge(user: current_user)
  end
end
