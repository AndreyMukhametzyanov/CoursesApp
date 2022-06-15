# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    resource = find_resource(file.record_type, file.record_id)
    return redirect_with_alert(root_path, I18n.t('attachment.error')) unless owned_by_user?(resource)

    file.purge
    redirect_to_resource(resource)
  end

  private

  def redirect_to_resource(resource)
    case resource
    when Lesson
      redirect_with_notice(course_lesson_path(resource.course.id, resource.id), I18n.t('attachment.delete'))
    when Course
      redirect_with_notice(promo_course_path(resource.id), I18n.t('attachment.delete'))
    else
      redirect_with_alert(root_path, I18n.t('attachment.error'))
    end
  end

  def find_resource(klass, record_id)
    klass.constantize.find(record_id)
  end

  def owned_by_user?(resource)
    resource.respond_to?(:owner?) && resource.owner?(current_user)
  end
end
