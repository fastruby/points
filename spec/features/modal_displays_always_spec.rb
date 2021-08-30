require "rails_helper"

RSpec.describe "managing estimates" do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  before do
    login_as(user, scope: :user)
  end

  it "allows me to click on the modal twice in a row", js: true do
    visit project_path(id: project.id)
    click_link "Add Estimate"
    expect(page).to have_text("New Estimate")
    expect(page).to have_content(story.description)
    find(".close").click()


    click_link "points app"
    find(".project-card:nth-of-type(1)").click()
    click_link "Add Estimate"
    expect(page).to have_text("New Estimate")
    expect(page).to have_content(story.description)
  end
end
