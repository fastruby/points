require "rails_helper"

# The dashboard renders the madmin layout (including _javascript.html.erb),
# so this request spec also guards against layout/partial regressions such as
# the removed `npm_rails_version` helper.
RSpec.describe "Madmin dashboard", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }

  before { login_as(admin, scope: :user) }
  after { Warden.test_reset! }

  describe "GET /madmin" do
    it "renders the dashboard successfully" do
      get "/madmin"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("madmin")
    end
  end
end
