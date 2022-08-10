# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :set_course, except: :destroy

  def new
    if @course.owner?(current_user)
      @lesson = @course.lessons.build
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def create
    if @course.owner?(current_user)
      @lesson = @course.lessons.build(lesson_params)

      if @lesson.save
        @course.update_course_quantity
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :new
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def show
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
    elsif @course.enrolled_in_course?(current_user)
      @lesson = @course.lessons.find(params[:id])
      @order = Order.find_by(user_id: current_user.id, course: @course)
      @complete_exam = @order.exam_complete
      @complete_final_project = @order.project_complete
      @completed_lessons_ids = @order.completed_lessons_ids
      @percentage = @order.percentage_count
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.access_error'))
    end
  end

  def edit
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def update
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])

      if @lesson.update(lesson_params)
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :edit
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def complete
    order = Order.find_by(user_id: current_user.id, course: @course)

    if order.completed_lessons_ids.exclude?(params[:id].to_i)
      order.completed_lessons_ids << params[:id].to_i
      order.save
    end
    if next_lesson.empty?
      if @course.final_project
        redirect_to course_final_project_path(@course)
      elsif @course.exam
        redirect_to course_exam_path(@course)
      else
        redirect_with_notice(promo_course_path(@course), I18n.t('lessons.lessons_all_end'))
      end
    else
      redirect_with_notice(course_lesson_path(@course, next_lesson.first.id), I18n.t('lessons.lesson_end_msg'))
    end
  end

  def destroy; end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def lesson_params
    permit_params(
      :lesson, :title, :content, :youtube_video_id, :order_factor,
      files: [],
      links_attributes: %i[id address _destroy]
    )
  end

  def next_lesson
    lesson = @course.lessons.find(params[:id])
    @course.lessons.where('order_factor > ?', lesson.order_factor)
  end
end
