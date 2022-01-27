require "rails_helper"

RSpec.describe "home specs" do
  let(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, scope: :user)
  end

  context "with projects" do
    let!(:project) { FactoryBot.create(:project) }

    context "with sub projects" do
      let!(:sub_project1) { FactoryBot.create(:project, parent: project, position: 1) }
      let!(:sub_project2) { FactoryBot.create(:project, parent: project, position: 2) }
      let!(:sub_project3) { FactoryBot.create(:project, parent: project, position: 3) }

      it "allows re-arranging the sub projects", js: true do
        visit root_path
        save_screenshot

        first = find("a", text: sub_project1.title)
        last = find("a", text: sub_project3.title)

        # this will move `last` BEFORE `first`
        save_screenshot
        last.drag_to(first)
        save_screenshot
        sleep(0.1)
        save_screenshot
        expect(page).not_to have_selector("#project_#{project.id}.project-card.sorting")
        save_screenshot

        expect(sub_project1.reload.position).to eq 2
        expect(sub_project2.reload.position).to eq 3
        expect(sub_project3.reload.position).to eq 1
      end
    end
  end
end
