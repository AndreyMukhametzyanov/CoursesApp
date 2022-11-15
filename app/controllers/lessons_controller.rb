# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :set_course, except: :destroy

  def show
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
    elsif @course.enrolled_in_course?(current_user)
      @lesson = @course.lessons.find(params[:id])
      @order = Order.find_by(user_id: current_user.id, course: @course)
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.access_error'))
    end
  end

  def new
    if @course.owner?(current_user)
      @lesson = @course.lessons.build
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def edit
    if @course.owner?(current_user)
      @lesson = @course.lessons.find(params[:id])
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.lessons.change_error'))
    end
  end

  def create
    if @course.owner?(current_user)
      @lesson = @course.lessons.build(lesson_params)
      if @lesson.save
        redirect_to course_lesson_path(@course, @lesson)
      else
        render :new
      end
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

    order.complete_lesson!(params[:id]) if order.completed_lessons_ids.exclude?(params[:id].to_i)

    if next_lesson.empty?
      if @course.final_project
        redirect_to course_final_project_path(@course)
      elsif @course.exam
        redirect_to course_exam_path(@course)
      else
        redirect_with_notice(promo_course_path(@course), I18n.t('lessons.lessons_all_end'))
      end
    elsif remaining_lessons_ids(order).any?
      redirect_with_notice(course_lesson_path(@course, remaining_lessons_ids(order).first),
                           I18n.t('lessons.lesson_end_msg'))
    else
      redirect_with_notice(course_lesson_path(@course, next_lesson.first.id), I18n.t('lessons.lesson_end_msg'))
    end
  end

  def destroy; end

  def like
    render json: get_information('like')
  end

  def dislike
    render json: get_information('dislike')
  end

  private

  def get_information(kind)
    @lesson = @course.lessons.find(params[:id])
    @user_vote = current_user.votes.find_by(lesson: @lesson)
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      if @user_vote
        return redirect_with_alert(course_lesson_path(@course, @lesson), "uge #{kind}") if @user_vote.kind == kind.to_s

        kind == 'like' ? @user_vote.like! : @user_vote.dislike!
      else
        @vote = Vote.create(user: current_user, lesson: @lesson, kind: kind.to_s)
      end

      likes_count = Vote.where(kind: 'like').count
      dislikes_count = Vote.where(kind: 'dislike').count

      "{ status: :ok, kind: (:#{kind}), likes_count: #{likes_count}, dislike_count: #{dislikes_count} }"
    else
      '{ status: :not_authenticate }'
    end
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def lesson_params
    permit_params(
      :lesson, :title, :content, :youtube_video_id, :order_factor, :likes, :dislikes,
      files: [],
      links_attributes: %i[id address _destroy]
    )
  end

  def next_lesson
    lesson = @course.lessons.find(params[:id])
    @course.lessons.where('order_factor > ?', lesson.order_factor)
  end

  def remaining_lessons_ids(order)
    @course.lessons.ids - order.completed_lessons_ids
  end
end
