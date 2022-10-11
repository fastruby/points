require "rails_helper"

RSpec.describe CallbacksController, type: :controller do
  let(:user) do
    {email: "mockuser@example.com", name: "Mockuser"}
  end
  let(:info_hash) do
    OmniAuth::AuthHash::InfoHash.new(user)
  end
  let(:omniauth_mock) do
    OmniAuth::AuthHash.new(info: info_hash)
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["omniauth.auth"] = omniauth_mock
  end

  describe "#developer" do
    it "signs in and redirect to projects path" do
      get :developer
      expect(subject).to redirect_to("http://test.host/projects")
    end
  end
end
