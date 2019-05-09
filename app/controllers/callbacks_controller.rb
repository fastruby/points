class CallbacksController < Devise::OmniauthCallbacksController
  def github
    company = request.env["omniauth.auth"]['extra']['raw_info']['company']

    if company&.strip&.include? "@ombulabs"
      @user = User.from_omniauth(request.env["omniauth.auth"])
      sign_in_and_redirect @user
    else
      flash[:error] = "This application is only available to members of Ombu Labs."
      redirect_to new_user_session_path
    end
  end
end
