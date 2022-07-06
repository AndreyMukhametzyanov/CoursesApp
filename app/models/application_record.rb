# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  IMAGE_TYPE = %w[image/gif image/jpeg image/pjpeg image/png image/svg+xml
                  image/tiff image/vnd.microsoft.icon image/vnd.wap.wbmp image/webp].freeze

  def self.human_enum_name(enum_name, enum_value)
    enum_i18n_key = enum_name.to_s.pluralize
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_i18n_key}.#{enum_value}")
  end
end
