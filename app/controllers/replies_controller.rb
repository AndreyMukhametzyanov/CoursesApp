# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :set_course

  def create
    if @course.owner?(current_user)
      redirect_with_alert(course_final_project_path(@course), I18n.t('errors.reply.create_error'))
    else
      user_project = current_user.user_projects.find_by(final_project: @course.final_project)
      @reply = user_project.replies.build(user_replies_params)
      if @reply.save
        redirect_with_notice(course_final_project_path(@course), I18n.t('reply.create'))
      else
        redirect_with_alert(course_final_project_path(@course), @reply.errors.full_messages.first)
      end
    end
  end

  def update
    if @course.owner?(current_user)
      user_replies = Reply.includes(:user).each do |reply|
        reply.user.first_name
      end
      else
    end
  end

  private

  def user_replies_params
    permit_params(:reply, :user_reply, files: [])
  end

  def teacher_replies_params
    permit_params(:reply, :teacher_comment, :status)
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end
