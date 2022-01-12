require "rails_helper"

RSpec.describe "managing estimates", js: true do
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
      set_estimates(3, 8)
      click_button "Create"
      expect(Estimate.count).to eq 1

      expect(page).to have_content "3"
      expect(page).to have_content "8"
    end

    it "allows me to add an estimate", js: false do
      set_estimates(3, 8)
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
      set_estimates(1, 2)
      click_button "Save Changes"

      expect(page).to have_content "1"
      expect(page).to have_content "2"
    end

    it "allows me to edit an estimate", js: false do
      set_estimates(1, 2)
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
      set_estimates(21, 1)
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

  context "using ajax" do
    it "uses a modal to estimate" do
      visit project_path(id: project.id)
      click_link "Add Estimate"

      within_modal do
        expect(page).to have_text("New Estimate")
        expect(page).to have_content(story.description)
        expect(current_path).to eq project_path(id: project.id)

        set_estimates(3, 8)
        click_button "Create"
      end
      expect_closed_modal

      expect_story_estimates(story, 3, 8)
      expect(page).to_not have_content(story.description)

      click_link "Edit Estimate"

      within_modal do
        expect(page).to have_text("Edit Estimate")
        expect(current_path).to eq project_path(id: project.id)
        expect(page).to have_content(story.description)

        set_estimates(5, 8)
        click_button "Save Changes"
      end
      expect_closed_modal

      expect_story_estimates(story, 5, 8)

      click_link "Edit Estimate"

      within_modal do
        set_estimates(5, 13)
        click_button "Save Changes"
      end
      expect_closed_modal

      expect_story_estimates(story, 5, 13)
    end

    it "allows estimation deletion" do
      visit project_path(id: project.id)
      click_link "Add Estimate"

      within_modal do
        expect(page).to have_text("New Estimate")
        expect(page).to have_content(story.description)
        expect(current_path).to eq project_path(id: project.id)

        set_estimates(5, 8)

        # make sure the delete button is not there during creation
        expect(page).to have_selector("a", text: "Delete Estimate", count: 0)

        click_button "Create"
      end
      expect_closed_modal

      expect_story_estimates(story, 5, 8)
      expect(page).to_not have_content(story.description)

      click_link "Edit Estimate"

      within_modal do
        expect(page).to have_text("Edit Estimate")

        accept_confirm do
          click_link "Delete Estimate"
        end
      end
      expect_closed_modal

      expect(page).to_not have_text("Edit Estimate")
    end
  end
end
