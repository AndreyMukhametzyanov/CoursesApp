# frozen_string_literal: true

class ExaminationsController < ApplicationController
  def show
    @examination = Examination.find(params[:id])

    if @examination.pass_exam
      redirect_to result_examination_path(@examination)
    else
      @current_question = @examination.current_question
    end

  end

  def check_answer
    examination = Examination.find(params[:id])
    answers = examination.current_question.answers.where('correct_answer=true').map { |answer| answer.id }

    user_answers = params[:user_answers].nil? ? [] : params[:user_answers]['current_question'].map { |answer| answer.to_i }

    puts answers.inspect
    puts user_answers.inspect

    correct_answer = examination.correct_answers

    if examination.next_question.nil?
      if (answers - user_answers).empty?
        correct_answer += 1
      end
      examination.update(correct_answers: correct_answer,
                         percentage_passing: percent_count(correct_answer, examination.exam.questions.count),
                         pass_exam: true)
    else
      if (answers - user_answers).empty?
        correct_answer += 1
      end

      current_question = examination.next_question
      next_question = examination.exam.questions.where("id > #{current_question.id}").first

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

end
