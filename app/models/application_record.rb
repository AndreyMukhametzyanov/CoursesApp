# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  IMAGE_TYPE = %w[image/gif image/jpeg image/pjpeg image/png image/svg+xml
                  image/tiff image/vnd.microsoft.icon image/vnd.wap.wbmp image/webp].freeze
end
