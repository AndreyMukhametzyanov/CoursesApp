# frozen_string_literal: true

class CoursesController < ApplicationController
  def index
    @courses = Course.all.order(:name)
  end

  def new
    @course = Course.new
  end

  def create
    @course = current_user.developed_courses.build(course_params)
    if @course.save
      redirect_to courses_path
    else
      render :new
    end
  end

  def edit
    @course = Course.find_by(id: params[:id])
    return if @course.owner?(current_user)

    redirect_with_alert
  end

  def update
    @course = Course.find_by(id: params[:id])
    if @course.owner?(current_user)
      if @course.update(course_params)
        redirect_to courses_path
      else
        render :edit
      end
    else
      redirect_with_alert
    end
  end

  def promo
    @course = Course.find_by(id: params[:id])
  end

  def start
    @course = Course.find_by(id: params[:id])
    @lesson = @course.lessons.first
    if @lesson
      redirect_to course_lesson_path(@course, @lesson)
    else
      flash[:alert] = I18n.t('errors.courses.access_error')
      redirect_to promo_course_path
    end
  end

  def order
    @order = Order.create(user_id: current_user.id, course_id: params[:id])
    if @order.save
      flash[:notice] = I18n.t 'orders.create_order.success'
      redirect_to promo_course_path(params[:id])
    else
      flash[:alert] = I18n.t 'orders.create_order.error'
      redirect_to root_path
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :level, :description, :video_link)
  end

  def redirect_with_alert
    flash[:alert] = I18n.t('errors.courses.change_error')
    redirect_to courses_path
  end
end
