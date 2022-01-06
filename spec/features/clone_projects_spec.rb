require "rails_helper"

RSpec.describe "cloning projects", js: true do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }

  before do
    login_as(user, scope: :user)
  end

  it "can clone a parent project" do
    visit project_path(id: project.id)

    click_link "Clone Project"

    expect(page).to have_text("Clone project #{project.title}")

    fill_in :project_title, with: "Cloned Project"

    expect {
      click_button "Clone"
    }.to change(Project, :count).by(1)

    expect(page).to have_text("Project cloned")

    last_project = Project.last
    expect(last_project.id).not_to eq(project.id)
    expect(last_project.stories.count).to eq project.stories.count

    expect(page).to have_text(last_project.title)
  end

  context "with sub projects" do
    let(:sub_project) { FactoryBot.create(:project, parent: project) }

    it "clones the sub projects when cloning a parent" do
      visit clone_project_path(id: project.id)
      expect {
        click_button "Clone"
      }.to change(Project, :count).by(1)

      expect(page).to have_text("Project cloned")

      last_project = Project.last
      expect(last_project.id).not_to eq(project.id)
      expect(project.projects.count).to eq(1)
      expect(last_project.projects.count).to eq project.projects.count
    end

    it "clones a sub project in the same parent" do
      visit clone_project_path(id: sub_project.id)

      expect {
        click_button "Clone"
      }.to change(project.projects.reload, :count).by(1)

      expect(page).to have_text("Project cloned")

      last_project = project.projects.reload.last
      expect(last_project.id).not_to eq(sub_project.id)
    end

    it "clones a sub project as a parent project" do
      visit clone_project_path(id: sub_project.id)

      expect {
        click_button "Clone"
      }.to change(Project, :count).by(1)

      expect(page).to have_text("Project cloned")

      last_project = project.projects.reload.last
      expect(last_project.parent).to be_nil
    end

    it "clones a sub project in another parent" do
      visit clone_project_path(id: sub_project.id)

      expect {
        click_button "Clone"
      }.to change(Project, :count).by(1)

      expect(page).to have_text("Project cloned")

      last_project = project.projects.reload.last
      expect(last_project.parent).not_to eq(project)
      expect(last_project.parent).to be_present
    end
  end
end
