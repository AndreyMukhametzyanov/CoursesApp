# frozen_string_literal: true

class CommentsController < ApplicationController

  def create
    comment = commentable.comments.build(comment_params)
    if comment.save
      flash[:notice] = I18n.t('comments.create.success')
      if commentable.class == 'Course'
        redirect_to promo_course_path
      elsif commentable.class == 'Lesson'
        redirect_to courses_lessons_path
      end
    else
      flash[:notice] = I18n.t('comments.create.error')
    end
  end

  private

    def commentable
      if params[:lesson_id].nil?
        @commentable ||= Course.find_by(id: params[:course_id])
      else
        @commentable ||= Lesson.find_by(id: params[:lesson_id])
      end
    end

    def comment_params
      params.require(:comment).permit(:body).merge(user: current_user)
    end
end
