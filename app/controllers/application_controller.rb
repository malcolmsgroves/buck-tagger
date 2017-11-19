class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session # :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :birthdate, :picture])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :birthdate, :picture])
  end

end
