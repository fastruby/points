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
    context "with a proxy_to param" do
      it "redirects to provided host" do
        get :github, params: {proxy_to: "http://example.com", code: "code", state: "state"}
        expect(subject).to redirect_to("http://example.com/users/auth/github/callback?code=code&state=state")
      end
    end

    context "without a proxy_to param" do
      it "redirects user to sign in" do
        CallbacksController.any_instance.stub(:organization_members).and_return([])
        get :github, params: {code: "code", state: "state"}
        expect(subject).to redirect_to("http://test.host/users/sign_in")
      end
    end
  end
end
