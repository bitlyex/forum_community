class ApplicationController < ActionController::Base
  include Pundit 
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :pundit_error 
  rescue_from ActiveRecord::RecordNotFound, with: :pundit_error
  rescue_from ActionController::UnknownFormat, with: :pundit_error!
  rescue_from NoMethodError, :with => :try_some_options

  before_action :configure_permitted_paramaters, if: :devise_controller?

  private

  def try_some_options
    flash[:alert] = 'You need to sign in or sign up before contiuning'
    redirect_to new_user_session_path(@thread)
  end

	def pundit_error!
    flash[:alert] = 'You need to sign in or sign up before contiuning'
		redirect_to new_user_session_path(@thread)
	end

  def pundit_error
    flash[:notice] = 'You need to sign in or sign up before contiuning'
    redirect_to new_user_session_path(@thread)
  end

  def configure_permitted_paramaters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
