class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #before_action :authenticate_user!
  #include CanCan::ControllerAdditions

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :file=> "#{Rails.root}/public/404.html"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :city])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :city, :role])
  end

  def user_params
  	params.require(:user).permit(:name, :email, :city, :password, :password_confirmation, :role)
	end

end
