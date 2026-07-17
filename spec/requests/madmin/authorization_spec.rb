require "rails_helper"

# The madmin interface is gated by Madmin::ApplicationController#ensure_admin,
# which redirects anyone who is not a signed-in admin back to the root path.
# These specs lock that behavior down across a representative set of routes.
RSpec.describe "Madmin authorization", type: :request do
  after { Warden.test_reset! }

  # One route per controller under /madmin, enough to prove the shared
  # before_action guards every resource and the dashboard.
  let(:guarded_paths) do
    [
      "/madmin",
      "/madmin/projects",
      "/madmin/stories",
      "/madmin/estimates",
      "/madmin/users",
      "/madmin/version_jumps"
    ]
  end

  context "when not signed in" do
    it "redirects every madmin path to the root path" do
      guarded_paths.each do |path|
        get path
        expect(response).to redirect_to("/"), "expected #{path} to redirect to /"
      end
    end
  end

  context "when signed in as a non-admin user" do
    let(:user) { FactoryBot.create(:user, admin: false) }

    before { login_as(user, scope: :user) }

    it "redirects every madmin path to the root path" do
      guarded_paths.each do |path|
        get path
        expect(response).to redirect_to("/"), "expected #{path} to redirect to /"
      end
    end
  end

  context "when signed in as an admin user" do
    let(:admin) { FactoryBot.create(:user, :admin) }

    before { login_as(admin, scope: :user) }

    it "grants access to every madmin path" do
      guarded_paths.each do |path|
        get path
        expect(response).to have_http_status(:ok), "expected #{path} to return 200"
      end
    end
  end
end
