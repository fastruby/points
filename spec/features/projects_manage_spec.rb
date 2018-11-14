require 'rails_helper'

RSpec.describe 'managing projects' do

  let(:user) {FactoryBot.create(:user)}
  let(:project) {FactoryBot.create(:project)}

  before do
    login_as(user, :scope => :user)
  end

  it "allows me to log in" do
    visit root_path
    expect(page).to have_content "Log out"
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
end
