class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook

    #if request.env["omniauth.auth"].info.email.blank?
     # redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
    #end
    
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])#, flash)
    if @user.persisted?
      sign_in @user #, :event => :authentication #this will throw if @user is not activated
      if current_user.role == 'client'
        redirect_to all_events_path
      elsif current_user.role == 'owner'
        redirect_to your_events_path
      elsif current_user.role == 'admin'
        redirect_to events_all_path
      else
        redirect_to banned_path
      end
      #redirect_to edit_user_registration_path
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
     session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end

  def failure
    redirect_to new_user_registration_path
  end
  
end