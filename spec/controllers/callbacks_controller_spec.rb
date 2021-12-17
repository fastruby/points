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
    it "redirects user to sign in" do
      allow_any_instance_of(CallbacksController).to receive(:organization_members).and_return([])
      get :github, params: {code: "code", state: "state"}
      expect(subject).to redirect_to("http://test.host/users/sign_in")
    end
  end
end
