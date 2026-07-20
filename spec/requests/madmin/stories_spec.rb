require "rails_helper"

# Stories are registered with the full set of resource routes, so this exercises
# create/update in addition to the read-only actions.
RSpec.describe "Madmin stories", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  before { login_as(admin, scope: :user) }
  after { Warden.test_reset! }

  describe "GET /madmin/stories" do
    it "lists stories" do
      get "/madmin/stories"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/stories/new" do
    it "renders the new form" do
      get "/madmin/stories/new"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/stories/:id" do
    it "shows the story" do
      get "/madmin/stories/#{story.id}"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/stories/:id/edit" do
    it "renders the edit form" do
      get "/madmin/stories/#{story.id}/edit"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /madmin/stories" do
    it "creates a story" do
      expect {
        post "/madmin/stories", params: {
          story: {
            title: "A brand new story",
            description: "Some description",
            real_score: 3,
            project_id: project.id
          }
        }
      }.to change(Story, :count).by(1)

      expect(response).to have_http_status(:redirect)
      expect(Story.last.title).to eq("A brand new story")
    end
  end

  describe "PATCH /madmin/stories/:id" do
    it "updates the story" do
      patch "/madmin/stories/#{story.id}", params: {
        story: {title: "Updated title"}
      }

      expect(response).to have_http_status(:redirect)
      expect(story.reload.title).to eq("Updated title")
    end
  end

  describe "DELETE /madmin/stories/:id" do
    it "destroys the story" do
      expect {
        delete "/madmin/stories/#{story.id}"
      }.to change(Story, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
