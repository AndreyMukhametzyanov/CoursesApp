# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :set_course
  before_action :set_user_project, only: :create
  before_action :check_execution_time, only: :create

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
      @reply = Reply.find(params[:id])
      if @reply.update(teacher_replies_params)
        redirect_with_notice(course_final_project_path(@course), I18n.t('reply.teacher_reply'))
      else
        redirect_with_alert(course_final_project_path(@course), @reply.errors.full_messages.first)
      end
    else
      redirect_to course_final_project_path(@course)
    end
  end

  private

  def check_execution_time
    if @user_project.time_is_over?
      redirect_with_alert(course_final_project_path(@course), I18n.t('errors.reply.time_is_over'))
    end
  end

  def user_replies_params
    permit_params(:reply, :user_reply, files: [])
  end

  def teacher_replies_params
    permit_params(:reply, :teacher_comment, :status)
  end

  def set_user_project
    @user_project = UserProject.find_by(final_project: @course.final_project, user: current_user)
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end
