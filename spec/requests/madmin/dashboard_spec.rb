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

    it "renders stat tiles instead of the old resource link grid" do
      get "/madmin"

      expect(response.body).to include("Active projects")
      expect(response.body).to include("Pending stories")
      expect(response.body).to include("Approved stories")
      expect(response.body).to include("Estimates")
      # The dashboard used to be a grid of links into each admin section,
      # which duplicated the sidebar. That copy should be gone.
      expect(response.body).not_to include("Jump to any admin section")
    end

    it "lists recent records with links to their madmin pages" do
      story = FactoryBot.create(:story, title: "Recently added story")

      get "/madmin"

      expect(response.body).to include("Recent stories")
      expect(response.body).to include("Recent projects")
      expect(response.body).to include("Recent estimates")
      expect(response.body).to include("Recently added story")
      expect(response.body).to include(madmin_story_path(story))
    end

    it "renders the Dashboard link in the sidebar navigation" do
      get "/madmin"

      expect(response.body).to include("Dashboard")
      expect(response.body).to include("href=\"#{madmin_root_path}\"")
    end
  end
end
