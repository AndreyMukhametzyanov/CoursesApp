# frozen_string_literal: true

class LessonsController < ApplicationController
  def index
    @lessons = Lesson.all
  end

  def new
    @course = Course.find_by_id(params[:course_id])
    @lesson = Lesson.new
  end

  def create
    @course = Course.find_by_id(params[:course_id])
    @lesson = @course.lessons.build(lesson_params)
    if @lesson.save
      redirect_to course_lesson_path(@course, @lesson)
    else
      render :new
    end
  end

  def show
    @course = Course.find_by_id(params[:course_id])
    @lesson = @course.lessons.find(params[:id])
  end

  def edit
    @course = Course.find_by_id(params[:course_id])
    @lesson = @course.lessons.find(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:course_id])
    @lesson = @course.lessons.find(params[:id])
    if @lesson.update(lesson_params)
      redirect_to course_lesson_path(@course, @lesson)
    else
      render :edit
    end
  end

  def destroy; end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :content, :youtube_video_id, :order_factor)
  end
end
