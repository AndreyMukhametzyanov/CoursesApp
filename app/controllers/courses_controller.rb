# frozen_string_literal: true

class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.build(course_params)
    if @course.save
      redirect_to courses_path
    else
      render :new
    end
  end

  def show
    @course = Course.find_by_id(params[:id])
  end

  def edit; end

  def destroy; end

  def promo
    @course = Course.find_by_id(params[:id])
  end

  def start
    redirect_to course_lesson_path(@course, @lesson)
  end

  private

  def course_params
    params.require(:course).permit(:name, :level, :description)
  end
end
