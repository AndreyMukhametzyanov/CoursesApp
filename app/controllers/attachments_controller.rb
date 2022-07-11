# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    resource = find_resource(@file.record_type, @file.record_id)
    return head :unauthorized unless owned_by_user?(resource)

    @file.purge
  end

  private

  def find_resource(klass, record_id)
    klass.constantize.find(record_id)
  end

  def owned_by_user?(resource)
    resource.respond_to?(:owner?) && resource.owner?(current_user)
  end
end
