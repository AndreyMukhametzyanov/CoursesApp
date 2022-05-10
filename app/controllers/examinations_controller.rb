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

  end

  def result

  end
end
