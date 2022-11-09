# frozen_string_literal: true

class UsersAccountsController < ApplicationController
  def created_courses
    @courses = Course.where(author: current_user)
  end

  def certificates
    @certificates = current_user.certificates
  end

  def studied_courses
    @studied_courses = current_user.orders
  end

  def students_reply
    @replies = Reply.joins(user_project: { final_project: :course })
                    .where(courses: { author: current_user }).where(status: 'verification')
  end
end
