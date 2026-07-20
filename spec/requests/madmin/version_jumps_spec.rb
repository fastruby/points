require "rails_helper"

# Version jumps are registered with the full set of resource routes, so this
# exercises create/update in addition to the read-only actions.
RSpec.describe "Madmin version jumps", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:version_jump) do
    FactoryBot.create(:version_jump, technology: "RailsUpgrade", initial_version: "6.1", target_version: "7.0")
  end

  before { login_as(admin, scope: :user) }
  after { Warden.test_reset! }

  describe "GET /madmin/version_jumps" do
    it "lists version jumps" do
      get "/madmin/version_jumps"

      expect(response).to have_http_status(:ok)
    end

    it "shows the technology and versions, not just the id" do
      get "/madmin/version_jumps"

      expect(response.body).to include("RailsUpgrade")
      expect(response.body).to include("6.1")
      expect(response.body).to include("7.0")
    end
  end

  describe "GET /madmin/version_jumps/new" do
    it "renders the new form" do
      get "/madmin/version_jumps/new"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/version_jumps/:id" do
    it "shows the version jump" do
      get "/madmin/version_jumps/#{version_jump.id}"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/version_jumps/:id/edit" do
    it "renders the edit form" do
      get "/madmin/version_jumps/#{version_jump.id}/edit"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /madmin/version_jumps" do
    it "creates a version jump" do
      expect {
        post "/madmin/version_jumps", params: {
          version_jump: {
            technology: "Rails-new",
            initial_version: "6.1",
            target_version: "7.0"
          }
        }
      }.to change(VersionJump, :count).by(1)

      expect(response).to have_http_status(:redirect)
      expect(VersionJump.last.technology).to eq("Rails-new")
    end
  end

  describe "PATCH /madmin/version_jumps/:id" do
    it "updates the version jump" do
      patch "/madmin/version_jumps/#{version_jump.id}", params: {
        version_jump: {target_version: "8.0"}
      }

      expect(response).to have_http_status(:redirect)
      expect(version_jump.reload.target_version).to eq("8.0")
    end
  end

  describe "DELETE /madmin/version_jumps/:id" do
    it "destroys the version jump" do
      expect {
        delete "/madmin/version_jumps/#{version_jump.id}"
      }.to change(VersionJump, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
