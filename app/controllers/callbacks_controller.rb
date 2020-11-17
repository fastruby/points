require "open-uri"

class CallbacksController < Devise::OmniauthCallbacksController
  def github
    username = request.env["omniauth.auth"]["extra"]["raw_info"]["login"]

    organization_name = ENV["ORGANIZATION_LOGIN"]
    member_logins = organization_members.map { |member| member["login"] }

    if username.in?(member_logins)
      @user = User.from_omniauth(request.env["omniauth.auth"])
      sign_in_and_redirect @user
    else
      flash[:error] = "This application is only available to members of #{organization_name}."
      redirect_to new_user_session_path
    end
  end

  private

  def organization_members
    @organization_members ||= begin
        members_raw_response = open("https://api.github.com/orgs/#{ENV["ORGANIZATION_LOGIN"]}/members").read
        JSON.parse(members_raw_response)
      end
  end
end
