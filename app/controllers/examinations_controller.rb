# frozen_string_literal: true

class ExaminationsController < ApplicationController
  before_action :set_examination

  def show
    @percent = @examination.answers_percentage

    if @examination.finished_exam || @examination.success_passed_exam?
      redirect_to course_exam_path(@examination.exam.course)
    else
      @current_question = @examination.current_question
    end
  end

  def check_answer
    @examination.correct_answers += 1 if (current_correct_answers - current_user_answer).empty?

    if @examination.time_is_over?
      @examination.update(
        percentage_passing: calc_percent_count,
        finished_exam: true
      )

      redirect_with_alert(course_exam_path(@examination.exam.course), I18n.t('errors.exam.end_time'))
    else
      if @examination.next_question.nil?
        @examination.percentage_passing = calc_percent_count
        @examination.passed_exam = @examination.success_passed_exam?
        @examination.finished_exam = true
      else
        @examination.current_question = @examination.next_question
        @examination.next_question = next_question
      end
      @examination.save!
      order = current_user.orders.find_by(course: @examination.exam.course)
      order.exam_complete!
      redirect_to examination_path(@examination)
    end
  end

  private

  def set_examination
    @examination = Examination.find(params[:id])
  end

  def current_user_answer
    @current_user_answer ||= params[:user_answers].nil? ? [] : params[:user_answers]['current_question'].map(&:to_i)
  end

  def current_correct_answers
    @current_correct_answers ||= @examination.current_correct_answers_ids
  end

  def next_question
    @examination.exam.questions.where('id > ?', @examination.next_question.id).first
  end

  def calc_percent_count
    (@examination.correct_answers * 100) / @examination.exam.questions.count
  end
end
