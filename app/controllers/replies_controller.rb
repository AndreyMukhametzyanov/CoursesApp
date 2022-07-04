# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :set_course

  def create

    final_project = @course.final_project
    user_project = current_user.user_projects.find_by(final_project: final_project)
    @reply = user_project.replies.build(replies_params)

  end

  private

  def replies_params
    permit_params(:reply, :teacher_comment, :user_reply, :status, files: [])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end
