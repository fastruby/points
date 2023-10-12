require "rails_helper"

RSpec.describe "story status", js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  before do
    login_as(user, scope: :user)
  end

  context "from the show page" do
    it "allows me to change the story status" do
      visit project_story_path(project_id: project.id, id: story.id)

      status_button = find(".dropdown-wrapper").find("button")

      status_button.click
      click_button("Approve")

      status_button = find(".dropdown-wrapper").find("button")

      expect(status_button).to have_text("approved")
    end
  end

  context "from the estimation modal" do
    it "allows me to change the story status" do
      visit project_path(id: project.id)
      click_link "Add Estimate"

      status_button = find(".story-title").find(".dropdown-wrapper").find("button")

      status_button.click
      click_button("Approve")

      status_button = find(".story-title").find(".dropdown-wrapper").find("button")

      expect(status_button).to have_text("approved")

      click_button "Save changes"

      status_badge = find(".project-table").find(".status").find(".story-status-badge")
      expect(status_badge).to have_text("approved")
    end
  end
end
