require "rails_helper"

RSpec.describe "managing stories", js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  before do
    login_as(user, scope: :user)
  end

  it "allows me to add a story" do
    visit project_path(id: project.id)
    click_link "Add a Story"
    fill_in "story[title]", with: "As a user, I want to add stories"
    fill_in "story[description]", with: "This story allows users to add stories."
    fill_in "story[extra_info]", with: "This story allows users to add extra details."
    click_button "Create"
    expect(Story.count).to eq 2
  end

  it "allows me to clone a story" do
    visit project_path(id: project.id)
    within_story_row(story) do
      click_button "More actions"
      click_link "Clone"
    end
    expect(page.find("#story_title").value).to eq story.title
    expect(page.find("#story_description").value).to eq story.description
    click_button "Create"
    expect(Story.count).to eq 2
  end

  it "allows me to edit a story" do
    visit project_path(id: project.id)
    click_button "More actions"
    click_link "Edit"
    fill_in "story[title]", with: "As a user, I want to edit stories"
    click_button "Save Changes"
    expect(page).to have_content "Story updated!"
  end

  it "allows me to delete a story" do
    visit project_path(id: project.id)

    expect(page).to have_text story.title

    accept_confirm do
      click_button "More actions"
      click_link "Delete"
    end

    expect(page).not_to have_text story.title
    expect(Story.count).to eq 0
  end

  it "allows me to delete a story from show page" do
    visit project_story_path(project, story)

    expect(page).to have_text story.title

    accept_confirm do
      click_link "Delete"
    end

    expect(page).not_to have_text story.title
    expect(Story.count).to eq 0
  end

  it "does not allow me to bulk delete stories when there are none selected" do
    visit project_path(id: project.id)
    expect(page).to have_selector("#bulk_delete[aria-disabled='true']")
    expect(page).to have_selector("#bulk_delete[disabled]")
  end

  it "allows me to bulk delete stories when one or more stories are selected" do
    visit project_path(id: project.id)

    within_story_row(story) { check(option: story.id.to_s) }
    expect(page).to have_no_selector("#bulk_delete[aria-disabled='true']")
    expect(page).to have_no_selector("#bulk_delete[disabled]")
    expect(page).to have_button("Bulk Delete (1 Story)")
    page.accept_confirm "Are you sure you want to delete 1 story?" do
      click_button("Bulk Delete (1 Story)")
    end
    # Make sure tbody empty
    expect(find("tbody")).to have_no_css("*")
    expect(Story.count).to eq 0
  end

  it "does not bulk delete stories when confirmation is dismissed" do
    visit project_path(id: project.id)

    within_story_row(story) { check(option: story.id.to_s) }
    expect(page).to have_no_selector("#bulk_delete[aria-disabled='true']")
    expect(page).to have_no_selector("#bulk_delete[disabled]")
    expect(page).to have_button("Bulk Delete (1 Story)")
    page.dismiss_confirm "Are you sure you want to delete 1 story?" do
      click_button("Bulk Delete (1 Story)")
    end
    expect(Story.count).to eq 1
  end

  it "shows a preview of the description while typing", js: true do
    visit project_path(id: project.id)
    click_link "Add a Story"
    fill_in "story[title]", with: "As a user, I want to add stories"

    desc = <<~DESC
      This story allows users to add stories.

          some
          code

    DESC

    expect(page).to have_text("Description Preview")
    fill_in "story[description]", with: desc
    expect(find("#story_description").value).to have_text("This story allows users to add stories.\n\n    some\n    code\n\n")

    within(".story_preview .content") do
      expect(page).to have_text("This story allows users to add stories.")
      expect(page).to have_selector("pre", text: "some\ncode")
    end

    click_button "Create"

    expect(page).to have_text(project.title)

    story = Story.last
    within_story_row(story) do
      click_button "More actions"
      click_link "Edit"
    end

    expect(page).to have_text("Edit Story")

    within(".story_preview .content") do
      expect(page).to have_text("This story allows users to add stories.")
      expect(page).to have_selector("pre", text: "some\ncode")
    end
  end

  it "shows a preview of the extra information while typing" do
    visit project_path(id: project.id)
    click_link "Add a Story"
    fill_in "story[title]", with: "As a user, I want to add stories"

    desc = <<~DESC
      This story allows users to add extra information.

          some
          codes

    DESC

    expect(page).to have_text("Extra Info Preview")
    fill_in "story[extra_info]", with: desc

    within(".extra_info_preview .content") do
      expect(page).to have_selector("p", text: "This story allows users to add extra information.")
      expect(page).to have_selector("pre", text: "some\ncodes")
    end

    click_button "Create"

    expect(page).to have_text(project.title)

    story = Story.last
    within_story_row(story) do
      click_button "More actions"
      click_link "Edit"
    end

    expect(page).to have_text("Edit Story")

    within(".extra_info_preview .content") do
      expect(page).to have_selector("p", text: "This story allows users to add extra information.")
      expect(page).to have_selector("pre", text: "some\ncodes")
    end
  end

  it "can move stories between siblings" do
    project2 = FactoryBot.create(:project, parent: project)
    project3 = FactoryBot.create(:project, parent: project)
    story = FactoryBot.create(:story, project: project2)

    visit project_path(id: project2.id)

    within_story_row(story) do
      # move to options are hidden
      expect(page).not_to have_text project3.title

      click_button "More actions"
      click_button "Move to"

      # only one option is to move to since there's only one sibling
      expect(page).to have_selector ".move-story .dropdown > form", count: 1

      # confirm moving the story
      accept_confirm do
        click_button project3.title
      end
    end

    expect(page).to have_text "Story moved"
    expect(page).not_to have_text story.title
    expect(story.reload.project).to eq project3
  end

  # see issue #9 on github
  it "preserves order of stories when editing" do
    empty_project = FactoryBot.create(:project)
    visit project_path(id: empty_project.id)
    click_link "Add a Story"
    fill_in "Title", with: "Story 1"
    fill_in "Description (Markdown)", with: "desc"
    click_button "Create"

    # check that it adds a position for new stories
    story1 = Story.last
    expect(story1.position).to be 1

    click_link "Add a Story"
    fill_in "Title", with: "Story 2"
    fill_in "Description (Markdown)", with: "desc"
    click_button "Create"

    story2 = Story.last
    expect(story2.position).to be 2

    # check that the order is not broken after edit for stories with no position
    story1.update_attribute(:position, nil)
    story2.update_attribute(:position, nil)

    within("#story_#{story1.id}") do
      click_button "More actions"
      click_link "Edit"
    end

    expect(page).to have_text("Edit Story")

    fill_in "Description (Markdown)", with: "desc2"

    click_button "Save Changes"

    expect(page).to have_text("Story updated!")

    within("#stories") do
      expect(find("tr:nth-child(1)")).to have_text story1.title
      expect(find("tr:nth-child(2)")).to have_text story2.title
    end

    # check that stories with nil position are listed first

    click_link "Add a Story"
    fill_in "Title", with: "Story 3"
    fill_in "Description (Markdown)", with: "desc"
    click_button "Create"

    story3 = Story.last
    expect(story3.position).to be 1

    within("#stories") do
      expect(find("tr:nth-child(1)")).to have_text story1.title
      expect(find("tr:nth-child(2)")).to have_text story2.title
      expect(find("tr:nth-child(3)")).to have_text story3.title
    end
  end

  it "allows sorting stories", js: true do
    FactoryBot.create(:story, project: project, title: "Juan and Aysan Code!")
    story3 = FactoryBot.create(:story, project: project, title: "Last story")

    visit project_path(project)

    first = find(".project-table__cell", text: story.title)
    last = find(".project-table__cell", text: story3.title)

    # The use expect_any_instance_of is discouraged by the RSpec team, but the drag_to
    # method is not always consistent on the distance it drags elements and the order
    # is not always the expected. So I'm using expect_any_instance_of on purpose here.
    expect_any_instance_of(ProjectsController).to receive(:sort_stories)

    last.drag_to(first, delay: 0, html5: false)

    within("#stories") do
      expect(find("tr:nth-child(1)")).to have_text story3.title
      expect(find("tr:nth-child(2)")).to have_text story.title
    end

    expect(page).not_to have_selector(".project-table.sorting")
  end
end
