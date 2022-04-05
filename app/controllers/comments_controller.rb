# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    commentable.comments.create(comment_params).tap do |comment|
      prepare_flash(comment)
      redirect(commentable)
    end
  end

  private

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
      flash[:alert] = comment.errors.full_messages.first
    else
      flash[:notice] = I18n.t('comments.create.success')
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
