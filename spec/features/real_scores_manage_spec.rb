require "rails_helper"

RSpec.describe "managing real scores", js: true do
  let!(:user) { FactoryBot.create(:user, :admin, name: "John") }
  let(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  before do
    login_as(user, scope: :user)
  end

  it "allows me to edit a real score" do
    visit project_report_path(project.id)
    click_link "Populate Real Scores"
    fill_in "stories[story_#{story.id}]", with: 5
    click_button "Submit"
    expect(story.reload.real_score).to eq 5
  end
end
