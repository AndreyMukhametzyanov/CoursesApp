# frozen_string_literal: true

class LessonsController < ApplicationController
  def new
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.build
    else
      redirect_with_alert
    end
  end

  def create
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.build(lesson_params)
      if @lesson.save
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :new
      end
    else
      redirect_with_alert
    end
  end

  def show
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @lesson = @course.lessons.find(params[:id])
    else
      flash[:alert] = I18n.t 'errors.lessons.access_error'
      redirect_to promo_course_path(@course)
    end
  end

  def edit
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
    else
      redirect_with_alert
    end
  end

  def update
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
      if @lesson.update(lesson_params)
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :edit
      end
    else
      redirect_with_alert
    end
  end

  def destroy; end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :content, :youtube_video_id, :order_factor, files: [])
  end

  def redirect_with_alert
    flash[:alert] = I18n.t('errors.lessons.change_error')
    redirect_to promo_course_path(@course)
  end
end
