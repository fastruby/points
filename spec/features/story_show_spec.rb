require "rails_helper"

RSpec.describe "story show", js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  before do
    login_as(user, scope: :user)
  end

  it "allows me to change the story state" do
    visit project_story_path(project_id: project.id, id: story.id)

    status_button = find(".dropdown-wrapper").find("button")

    status_button.click
    click_button("Approve")

    status_button = find(".dropdown-wrapper").find("button")

    expect(status_button).to have_text("approved")
  end
end
