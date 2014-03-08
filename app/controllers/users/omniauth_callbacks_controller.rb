class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # alias_method :fitbit, :all
  def fitbit
    user = User.from_omniauth(request.env["omniauth.auth"], current_user)
    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to  new_user_registration_path
    end
  end

end
