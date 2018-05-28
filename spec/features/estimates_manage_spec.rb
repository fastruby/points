require "rails_helper"

RSpec.describe "managing estimates" do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  before do
    login_as(user, scope: :user)
  end

  context "with one unestimated story" do
    before do
      visit project_path(id: project.id)
      click_link "Add Estimate"
    end

    it "shows me the story's title and description" do
      expect(page).to have_content(story.title)
      expect(page).to have_content(story.description)
    end

    it "allows me to add an estimate" do
      select "3", from: "estimate[best_case_points]"
      select "8", from: "estimate[worst_case_points]"
      click_button "Create"
      expect(Estimate.count).to eq 1
      expect(page).to have_content "Estimate created!"
    end
  end

  context "with one estimated story" do
    let!(:estimate) { FactoryBot.create(:estimate, story: story, user: user) }

    before do
      visit project_path(id: project.id)
      click_link "Edit Estimate"
    end

    it "shows me the story's title and description" do
      expect(page).to have_content(story.title)
      expect(page).to have_content(story.description)
    end

    it "allows me to edit an estimate" do
      select "1", from: "estimate[best_case_points]"
      select "2", from: "estimate[worst_case_points]"
      click_button "Save Changes"
      expect(page).to have_content "Estimate updated!"
    end
  end

  context "when best case estimate is greater than worst case estimate" do
    let!(:estimate) { FactoryBot.create(:estimate, story: story, user: user) }

    before do
      visit project_path(id: project.id)
      click_link "Edit Estimate"
    end

    it "shows me an error message" do
      select "21", from: "estimate[best_case_points]"
      select "1", from: "estimate[worst_case_points]"
      click_button "Save Changes"
      expect(page).to have_content "Validation error Worst case estimate should be greater than best case estimate."
    end
  end

  context "when the story doesn't have a description" do
    let!(:story) { FactoryBot.create(:story, project: project, description: nil) }

    before do
      visit project_path(id: project.id)
    end

    it "doesn't raise an error" do
      expect { click_link "Add Estimate" }.to_not raise_error
    end
  end
end
