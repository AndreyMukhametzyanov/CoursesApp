# frozen_string_literal: true

module ReplyHelper
  def reply_status_color(status)
    case status
    when 'verification'
      'bg-warning text-dark'
    when 'rejected'
      'bg-danger'
    when 'accepted'
      'bg-success'
    else
      'bg-secondary'
    end
  end
end
