# frozen_string_literal: true

class LessonsController < ApplicationController
  def index
    @lessons = Lesson.all
  end

  def new
    @lesson = Lesson.new
  end

  def create

  end

  def show
    @course = Course.find_by_id(params[:course_id])
    @lesson = @course.lessons.find(params[:id])
  end

  def edit; end

  def destroy; end
end
