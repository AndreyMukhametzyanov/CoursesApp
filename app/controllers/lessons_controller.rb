# frozen_string_literal: true

class LessonsController < ApplicationController
  def new
    @lesson = Lesson.new
  end

  def create; end

  def show
    @course = Course.find_by_id(params[:id])
  end

  def edit; end

  def destroy; end
end
