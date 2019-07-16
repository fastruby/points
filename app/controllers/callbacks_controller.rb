require 'open-uri'

class CallbacksController < Devise::OmniauthCallbacksController
  def github
    username = request.env["omniauth.auth"]['extra']['raw_info']['login']

    ombulabs_members_json = open('https://api.github.com/orgs/ombulabs/members').read
    ombulabs_members_parsed = JSON.parse(ombulabs_members_json)
    ombulabs_members = ombulabs_members_parsed.map { |member| member["login"] }

    if username.in?(ombulabs_members)
      @user = User.from_omniauth(request.env["omniauth.auth"])
      sign_in_and_redirect @user
    else
      flash[:error] = "This application is only available to members of Ombu Labs."
      redirect_to new_user_session_path
    end
  end
end
