# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    comment = commentable.comments.build(comment_params)
    comment.save ? flash[:notice] = I18n.t('comments.create.success') : flash[:alert] = I18n.t('comments.create.error')
    redirect_case(commentable)
  end

  private

  def commentable
    @commentable ||= if params[:lesson_id].nil?
                       Course.find_by(id: params[:course_id])
                     else
                       Lesson.find_by(id: params[:lesson_id])
                     end
  end

  def redirect_case(commentable)
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
