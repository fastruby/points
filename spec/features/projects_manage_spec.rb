require 'rails_helper'

RSpec.describe 'managing projects' do

  let(:user) {FactoryBot.create(:user)}
  let(:project) {FactoryBot.create(:project)}

  before do
    login_as(user, :scope => :user)
  end

  it "allows me to sign in" do
    visit root_path
    expect(page).to have_content "Sign out"
  end

  it "allows me to add a project" do
    visit root_path
    click_link 'Add a Project'
    fill_in 'project[title]', with: "Super Project"
    click_button 'Create'
    expect(Project.count).to eq 1
  end

  it "allows me to edit a project" do
    visit project_path(id: project.id)
    click_link 'Edit or Delete Project'
    fill_in 'project[title]', with: "New Project"
    click_button 'Save Changes'
    expect(page).to have_content "Project updated!"
  end

  it "allows me to delete a project" do
    visit project_path(id: project.id)
    click_link 'Edit or Delete Project'
    click_link 'Delete Project'
    expect(Project.count).to eq 0
  end

  context "import & Export" do

    before do
      project.stories.create(title: 'upgrade rails', description: 'php upgrade')
    end

    it "allows me to export a CSV" do
      visit project_path(id: project.id)
      find('#import-export').click
      click_on 'Export'
      expect(page.response_headers['Content-Type']).to eql "text/csv"
      expect(page.text).to include("php upgrade")
    end

    it "allows me to import a CSV" do
      visit project_path(id: project.id)
      find('#import-export').click
      page.attach_file('file', (Rails.root + 'spec/fixtures/test.csv').to_s)
      click_on 'Import'
      expect(project.stories.count).to be > 1
      expect(project.stories.map(&:title).join).to_not include("php upgrade")
      expect(page.text).to include("success")
      expect(page.current_path).to eql project_path(project.id)
    end
  end
end
