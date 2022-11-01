# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_course

  def create
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      commentable.comments.create(comment_params).tap do |comment|
        prepare_flash(comment)
        redirect(commentable)
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.courses.enrolled_error'))
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def commentable
    @commentable ||=
      if params[:lesson_id].nil?
        Course.find_by(id: params[:course_id])
      else
        Lesson.find_by(id: params[:lesson_id])
      end
  end

  def prepare_flash(comment)
    if comment.errors.any?
      flash.now[:alert] = comment.errors.full_messages.first
    else
      flash.now[:notice] = I18n.t('comments.create.success')
    end
  end

  def redirect(commentable)
    case commentable
    when Course
      redirect_to promo_course_path(params[:course_id])
    when Lesson
      redirect_to course_lesson_path(params[:course_id], params[:lesson_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
