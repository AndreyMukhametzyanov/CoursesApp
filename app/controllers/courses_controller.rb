# frozen_string_literal: true

class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    # render plain: course_params
    @course = current_user.courses.build(course_params)
    if @course.save
      redirect_to courses_path
    else
      render :new
    end
  end

  def edit
    @course = Course.find_by(id: params[:id])
  end

  def update
    @course = Course.find_by(id: params[:id])
    if @course.update(course_params)
      redirect_to courses_path
    else
      render :edit
    end
  end

  def promo
    @course = Course.find_by_id(params[:id])
  end

  def start
    @course = Course.find_by_id(params[:id])
    @lesson = @course.lessons.find(params[:id])
    redirect_to course_lesson_path(@course, @lesson)
  end

  private

  def course_params
    params.require(:course).permit(:name, :level, :description, :video_link)
  end
end
