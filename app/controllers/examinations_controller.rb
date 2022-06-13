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
    answers = @examination.current_correct_answers_ids
    correct_answer = @examination.correct_answers
    correct_answer += 1 if (answers - current_user_answer).empty?
    if @examination.time_is_over?
      @examination.update(percentage_passing: @examination.percent_count(correct_answer, @examination.exam.questions.count),
                          finished_exam: true)

      redirect_with_alert(course_exam_path(@examination.exam.course), I18n.t('errors.exam.end_time'))
    else
      if @examination.next_question.nil?
        @examination.update(correct_answers: correct_answer,
                            percentage_passing: @examination.percent_count(correct_answer, @examination.exam.questions.count),
                            finished_exam: true)
        @examination.update(passed_exam: true) if @examination.success_passed_exam?
      else
        @examination.update(current_question: @examination.next_question, correct_answers: correct_answer,
                            next_question: @examination.exam.questions.where('id > ?',
                                                                             @examination.next_question.id).first)
      end
      redirect_to examination_path(@examination.id)
    end
  end

  private

  def set_examination
    @examination = Examination.find(params[:id])
  end

  def current_user_answer
    params[:user_answers].nil? ? [] : params[:user_answers]['current_question'].map(&:to_i)
  end
end
