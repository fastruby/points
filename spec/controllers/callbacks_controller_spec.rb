require "rails_helper"

RSpec.describe CallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["omniauth.auth"] =
      OmniAuth.config.mock_auth[:github] =
        OmniAuth::AuthHash.new({"extra" => OmniAuth::AuthHash.new({
          "raw_info" => OmniAuth::AuthHash.new({"login" => "mockuser"})
        })})
  end

  describe "#github" do
    context "with a valid proxy request" do
      it "redirects to host" do
        proxy_to = "http://example.com"
        token = Token.issue("#{ENV["PROXY_SECRET"]}#{proxy_to}")
        get :github, params: {proxy_to: proxy_to, token: token, code: "code", state: "state"}
        expect(subject).to redirect_to("http://example.com/users/auth/github/callback?code=code&state=state")
      end
    end

    context "without a valid proxy request" do
      it "redirects user to sign in" do
        allow_any_instance_of(CallbacksController).to receive(:organization_members).and_return([])
        proxy_to = "http://example.com"
        get :github, params: {proxy_to: proxy_to, code: "code", state: "state"}
        expect(subject).to redirect_to("http://test.host/users/sign_in")
      end
    end
  end
end
