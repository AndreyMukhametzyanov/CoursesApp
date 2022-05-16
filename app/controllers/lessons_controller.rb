# frozen_string_literal: true

class LessonsController < ApplicationController
  def new
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.build
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def create
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.build(permit_params(:lesson, :title, :content, :youtube_video_id,
                                                    :order_factor, files: [],
                                                    links_attributes: %i[id address _destroy]))
      if @lesson.save
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :new
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def show
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @lesson = @course.lessons.find(params[:id])
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.access_error'))
    end
  end

  def edit
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def update
    @course = Course.find_by(id: params[:course_id])
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
      if @lesson.update(permit_params(:lesson, :title, :content, :youtube_video_id,
                                      :order_factor, files: [], links_attributes: %i[id address _destroy]))
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :edit
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def destroy; end
end
