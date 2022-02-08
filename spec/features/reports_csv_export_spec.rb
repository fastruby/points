require "rails_helper"

RSpec.describe "exporting reports to csv", js: true do
  let(:user) { FactoryBot.create(:user, :admin) }

  before { login_as(user, scope: :user) }

  context "story has only one estimate" do
    let(:estimate) { FactoryBot.create(:estimate) }
    let(:project) { estimate.story.project }

    it "renders download button" do
      visit project_report_path(project.id)
      expect(page).not_to have_link "Download Average Estimate Report"
    end
  end

  context "story has at least two estimates" do
    let(:project) { story.project }
    let(:story) { FactoryBot.create(:story) }

    before { FactoryBot.create_list(:estimate, 2, story: story) }

    it "renders download button" do
      visit project_report_path(project.id)
      expect(page).to have_link "Download Average Estimate Report", href: project_report_path(project, format: "csv")
    end
  end

  context "with no estimates" do
    let(:project) { FactoryBot.create(:project) }

    it "does not render download button" do
      visit project_report_path(project.id)
      expect(page).not_to have_link "Download Average Estimate Report"
    end
  end
end
