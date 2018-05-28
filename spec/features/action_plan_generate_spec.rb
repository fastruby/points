require 'rails_helper'

RSpec.describe "generating an action plan" do
  let(:admin_user) { FactoryBot.create(:user) }
  let(:project) do
    FactoryBot.create(:project).tap do |project|
      FactoryBot.create(:story, title: "Second Story", description: "Second", position: 2, project: project)
      FactoryBot.create(:story, title: "First Story", description: "First", position: 1, project: project)
    end
  end

  before { login_as(admin_user, scope: :user) }

  it "generates copy pasteable report" do
    visit project_path(project)
    click_link "Generate Action Plan"
    expect(page).to have_selector('h1', text: project.title)
    expect(page).to have_selector('h2', text: 'Action Plan')
    expect(page.all("#action-plan h3").map(&:text)).to eq(["First Story", "Second Story"])
    expect(page.all("#action-plan p").map(&:text)).to eq(["First", "Second"])
  end
end
