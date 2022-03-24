# frozen_string_literal: true

class LessonsController < ApplicationController
  def new
    @course = Course.find_by_id(params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.build
    else
      flash[:alert] = I18n.t('errors.create_error')
      redirect_to promo_course_path(@course)
    end
  end

  def create
    @course = Course.find_by_id(params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.build(lesson_params)
      if @lesson.save
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :new
      end
    else
      auth_alert
      redirect_to promo_course_path(@course)
    end
  end

  def show
    @course = Course.find_by_id(params[:course_id])
    @lesson = @course.lessons.find(params[:id])
  end

  def edit
    @course = Course.find_by_id(params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
    else
      auth_alert
      redirect_to promo_course_path(@course)
    end
  end

  def update
    @course = Course.find_by_id(params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
      if @lesson.update(lesson_params)
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :edit
      end
    else
      auth_alert
      redirect_to promo_course_path(@course)
    end
  end

  def destroy; end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :content, :youtube_video_id, :order_factor)
  end

  def auth_alert
    flash[:alert] = I18n.t('errors.edit_error')
  end
end
