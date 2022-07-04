class FinalProjectsController < ApplicationController
  before_action :set_course

  def new
    if @course.owner?(current_user)
      return redirect_to(edit_course_final_project_path(@course)) if @course.final_project.present?

      @final_project = @course.build_final_project
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.final_project.change_error'))
    end
  end

  def create
    if @course.owner?(current_user)
      @final_project = @course.create_final_project(final_project_params)

      if @final_project.save
        redirect_with_notice(promo_course_path(@course), I18n.t('final_project.create'))
      else
        render :new
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.final_project.change_error'))
    end
  end

  def edit
    if @course.owner?(current_user)
      @final_project = @course.final_project
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.final_project.change_error'))
    end
  end

  def show
    if @course.owner?(current_user) || @course.enrolled_in_course?(current_user)
      @final_project = @course.final_project
      @reply = Reply.new
      @user_project = UserProject.find_by(final_project: @final_project, user: current_user)
      @user_projects = @final_project.user_projects
      # @replied_user = User.find(user_project.user_id).first_name
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.final_project.access_error'))
    end
  end

  def update
    if @course.owner?(current_user)
      @final_project = @course.final_project
      if @final_project.update(final_project_params)
        redirect_with_notice(promo_course_path(@course), I18n.t('final_project.update'))
      else
        render :edit
      end
    else
      redirect_with_alert(promo_course_path(@course), I18n.t('errors.final_project.change_error'))
    end
  end

  def start
    unless @course.enrolled_in_course?(current_user) || @course.owner?(current_user)
      return redirect_with_alert(promo_course_path(@course), I18n.t('errors.courses.enrolled_error'))
    end

    if @course.final_project
      @user_project = UserProject.create(final_project: @course.final_project, user: current_user)
      redirect_to course_final_project_path(@course)
    else
      redirect_with_alert(promo_course_path, I18n.t('errors.final_project.not_create'))
    end
  end

  private

  def final_project_params
    permit_params(:final_project, :description, :short_description, :execution_days, files: [],)
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end