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

        first = find("a", text: sub_project1.title)
        last = find("a", text: sub_project3.title)

        # The use expect_any_instance_of is discouraged by the RSpec team, but the drag_to
        # method is not always consistent on the distance it drags elements and the order
        # is not always the expected. So I'm using expect_any_instance_of on purpose here.
        expect_any_instance_of(ProjectsController).to receive(:sort)

        last.drag_to(first, delay: 0, html5: false)

        expect(page).not_to have_selector("#project_#{project.id}.project-card.sorting")
      end
    end
  end
end
