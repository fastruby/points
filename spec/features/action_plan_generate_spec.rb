require "rails_helper"

RSpec.describe "generating an action plan", js: true do
  let(:admin_user) { FactoryBot.create(:user) }
  let(:parent) do
    FactoryBot.create(:project)
  end

  let!(:project) do
    FactoryBot.create(:project, parent: parent).tap do |project|
      FactoryBot.create(:story, title: "Second Story", description: "Second", position: 2, project: project, extra_info: "Extra Information")
      FactoryBot.create(:story, title: "First Story", description: "First", position: 1, project: project)
    end
  end

  let!(:project2) do
    FactoryBot.create(:project, parent: parent).tap do |project|
      FactoryBot.create(:story, title: "Third Story", description: "Third", position: 2, project: project)
      FactoryBot.create(:story, title: "Forth Story", description: "Forth", position: 1, project: project)
    end
  end

  before { login_as(admin_user, scope: :user) }

  it "generates copy pasteable action plan" do
    visit project_path(project)
    click_link "Generate Action Plan"

    # Check that content is there
    expect(page).to have_selector("h1", text: project.title)
    expect(page).to have_selector("h2", text: "Action Plan")
    expect(page).to have_selector("input[name='action-plan-prefix']")
    expect(page).to have_selector("h3.action-plan_heading > span", visible: false)
    expect(page.all("#action-plan h3").map(&:text)).to eq(["First Story", "Second Story"])
    # This assertion alsp ensure the extra_info key we populated doesn't appear
    expect(page.all("#action-plan p").map(&:text)).to eq(["First", "Second"])

    # Set prefix
    page.fill_in "action-plan-prefix", with: "3.2"
    expect(page.all(".action-plan_heading > span").map(&:text)).to eq(["3.2.1.", "3.2.2."])

    # Ensure that dot is not there when prefix input is empty
    page.fill_in "action-plan-prefix", with: " "
    expect(page.all("#action-plan h3").map(&:text)).to eq(["First Story", "Second Story"])
  end

  it "generates copy pasteable action plan for nested projects" do
    visit project_path(parent)
    click_link "Generate Action Plan"

    # Check that content is there
    expect(page).to have_selector("h1", text: parent.title)
    expect(page).to have_selector("h2", text: "Action Plan")
    expect(page).to have_selector("input[name='action-plan-prefix']")

    # Set prefix
    page.fill_in "action-plan-prefix", with: "3"
    expect(page.all(".action-plan_heading > span").map(&:text)).to eq(["3.1.", "3.1.1.", "3.1.2.", "3.2.", "3.2.1.", "3.2.2."])
  end
end
