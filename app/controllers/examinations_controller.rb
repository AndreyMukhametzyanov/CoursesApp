# frozen_string_literal: true

class ExaminationsController < ApplicationController
  def show
    @examination = Examination.find(params[:id])
    @percent = answers_percentage(@examination)
    if @examination.finished_exam
      redirect_to course_exam_path(@examination.exam.course)
    elsif success_passed_exam?(@examination.percentage_passing)
      redirect_to result_examination_path(@examination)
    else
      @current_question = @examination.current_question
    end
  end

  def check_answer
    examination = Examination.find(params[:id])
    answers = examination.current_question.answers.where(correct_answer: true).pluck(:id)
    user_answers = params[:user_answers].nil? ? [] : params[:user_answers]['current_question'].map(&:to_i)
    correct_answer = examination.correct_answers
    puts examination.current_question.created_at
    correct_answer += 1 if (answers - user_answers).empty?

    if examination.next_question.nil?
      examination.update(correct_answers: correct_answer,
                         percentage_passing: percent_count(correct_answer, examination.exam.questions.count),
                         finished_exam: true)
      if success_passed_exam?(examination.percentage_passing)
        examination.update(passed_exam: true)
      end
    else
      current_question = examination.next_question
      next_question = examination.exam.questions.where('id > ?', current_question.id).first
      examination.update(current_question: current_question,
                         next_question: next_question,
                         correct_answers: correct_answer)
    end
    redirect_to examination_path(examination.id)
  end

  def result
    @examination = Examination.find(params[:id])
  end

  private

  def percent_count(correct_answers, number_of_questions)
    (correct_answers * 100) / number_of_questions
  end

  def answers_percentage(model)
    ((model.exam.questions.where('id < ?',
                                 model.current_question.id).count.to_f / model.exam.questions.count) * 100).round(1)
  end

  def success_passed_exam?(percentage_passing)
    true if percentage_passing >= 80
  end

  def end_pass_time?(current_time, end_of_exam_time)
    #answer_time=>Time.now #end_of_exam_time => examination.exam.created_at + examination.exam.attempt_time
    true if current_time > end_of_exam_time
  end
end
