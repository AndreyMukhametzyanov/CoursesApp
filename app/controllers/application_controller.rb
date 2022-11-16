# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_locale

  def default_url_options
    I18n.default_locale == I18n.locale ? {} : { locale: I18n.locale }
  end

  protected

  def set_locale
    I18n.locale = I18n.locale_available?(params[:locale]) ? params[:locale] : I18n.default_locale
  end

  def redirect_with_alert(path, msg)
    redirect_by_kind(path, :alert, msg)
  end

  def redirect_with_notice(path, msg)
    redirect_by_kind(path, :notice, msg)
  end

  def redirect_by_kind(path, kind, msg)
    flash[kind] = msg
    redirect_to path
  end

  def permit_params(model, *filters)
    params.require(model).permit(filters)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :date_of_birth, :email, :password)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :date_of_birth, :password, :current_password)
    end
  end
end
