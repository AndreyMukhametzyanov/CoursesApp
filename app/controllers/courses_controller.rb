# frozen_string_literal: true

class CoursesController < ApplicationController
  def index
    @courses = Course.all.order(:name)
  end

  def new
    @course = Course.new
  end

  def create
    @course = current_user.developed_courses.build(permit_params(:course, :name, :level, :description,
                                                                 :video_link, :cover_picture))
    if @course.save
      redirect_to courses_path
    else
      render :new
    end
  end

  def edit
    @course = Course.find_by(id: params[:id])
    return if @course.owner?(current_user)

    redirect_with_alert(courses_path, I18n.t('errors.courses.change_error'))
  end

  def update
    @course = Course.find_by(id: params[:id])
    if @course.owner?(current_user)
      if @course.update(permit_params(:course, :name, :level, :description, :video_link, :cover_picture))
        redirect_to courses_path
      else
        render :edit
      end
    else
      redirect_with_alert(courses_path, I18n.t('errors.courses.change_error'))
    end
  end

  def promo
    @course = Course.find_by(id: params[:id])
  end

  def start
    @course = Course.find_by(id: params[:id])
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @lesson = @course.lessons.first
      return redirect_to(course_lesson_path(@course, @lesson)) if @lesson

      redirect_with_alert(promo_course_path, I18n.t('errors.lessons.access_error'))
    else
      redirect_with_alert(promo_course_path, I18n.t('errors.courses.enrolled_error'))
    end
  end

  def order
    @order = Order.create(user_id: current_user.id, course_id: params[:id])
    if @order.save
      redirect_with_notice(promo_course_path(params[:id]), I18n.t('orders.create_order.success'))
    else
      redirect_with_alert(root_path, I18n.t('orders.create_order.error'))
    end
  end
end
