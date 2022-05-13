# frozen_string_literal: true

class ExaminationsController < ApplicationController
  def show
    @examination = Examination.find(params[:id])

    if @examination.pass_exam
      redirect_to result
    else
      @current_question = @examination.current_question
    end

  end

  def check_answer
    examination = Examination.find(params[:id])
    answers = examination.current_question.answers.map { |answer| answer.id.to_s }
    user_answers = params[:user_answers]['current_question']

    puts answers.inspect
    puts user_answers.inspect

    correct_answer_counter = 0
    if examination.next_question.nil?

      if (answers - user_answers).empty?
        correct_answer_counter += 1
        examination.update(percentage_passing: percent_count(correct_answer_counter, examination.exam.questions.count),
                           pass_exam: true)
      end
    else
      if (answers - user_answers).empty?
        correct_answer_counter += 1
        current_question = examination.next_question
        next_question = examination.exam.questions.where("id > #{current_question.id}")

        examination.update(current_question: current_question,
                           next_question: next_question,
                           correct_answers: correct_answer_counter)
      end
    end
    redirect_to show
  end

  def result

  end

  private

  def percent_count(correct_answers, number_of_questions)
    (correct_answers * 100) / number_of_questions
  end
end
