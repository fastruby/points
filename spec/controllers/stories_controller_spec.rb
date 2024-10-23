require "rails_helper"

RSpec.describe StoriesController, type: :controller do
  render_views

  let!(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project, status: :approved) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe "#new" do
    it "redirects to the new page" do
      get :new, params: {id: story.id, project_id: project.id}
      expect(response).to render_template :new
    end
  end

  describe "#create" do
    context "with valid attributes" do
      let(:valid_params) { FactoryBot.attributes_for(:story) }

      it "creates a new story" do
        expect {
          post :create, params: {project_id: project.id, story: valid_params}
        }.to change(Story, :count).by(1)
      end

      it "redirects to the project path" do
        post :create, params: {project_id: project.id, story: valid_params}

        expect(response).to redirect_to project_path(project.id)
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { {title: ""} }

      before do
        post :create, params: {project_id: project.id, story: invalid_attributes}
      end

      it "stays on the new template page" do
        expect(response).to render_template :new
      end
    end
  end

  describe "#destroy" do
    it "deletes the story" do
      expect {
        delete :destroy, params: {id: story.id, project_id: project.id}
      }.to change(Story, :count).by(-1)
    end
  end

  context "when the story project is archived" do
    before do
      story.project.toggle_archived!
    end

    it "doesn't allow me to edit the story" do
      get :edit, params: {id: story.id, project_id: project.id}
      expect(response).to redirect_to project_path(project)
    end

    it "doesn't allow me to update the story" do
      put :update, params: {id: story.id, project_id: project.id, story: {title: "Changed Title"}}
      expect(response).to redirect_to project_path(project)
      expect(project.reload.title).not_to eq "Changed Title"
    end
  end

  context "when the story project is unarchived" do
    describe "#show" do
      before do
        get :show, params: {id: story.id, project_id: project.id}
      end

      it "redirects to the show page" do
        expect(response).to render_template :show
      end

      it "shows the attributes for the right story" do
        expect(assigns(:story)).to eq story
      end
    end

    describe "#show failure" do
      it "Throws 404 if the project_id doesn't match the story's project" do
        expect {
          get :show, params: {id: story.id, project_id: project.id + 1}
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "#edit" do
      before do
        get :edit, params: {id: story.id, project_id: project.id}
      end

      it "redirects to the edit page" do
        expect(response).to render_template :edit
      end

      it "shows the fields for the story" do
        expect(assigns(:story)).to eq story
      end
    end

    describe "#update" do
      it "updates the story" do
        put :update, params: {id: story.id,
                              project_id: project.id,
                              story: {title: "New Story"}}

        expect(story.reload.title).to eq "New Story"
      end
    end

    describe "#bulk_destroy" do
      let(:stories) { FactoryBot.create_list(:story, 2, project: project) }

      it "deletes multiple stories" do
        ids = stories.map(&:id)

        expect {
          post :bulk_destroy, params: {ids: ids}, format: :json
        }.to change(Story, :count).by(-2)
      end
    end

    describe "#move" do
      it "does not allow moving stories to non-sibling projects" do
        project2 = FactoryBot.create(:project, parent: project)
        project3 = FactoryBot.create(:project)
        story = FactoryBot.create(:story, project: project2)

        put :move, params: {project_id: project2.id, story_id: story.id, to_project: project3.id}
        expect(flash[:error]).to eq "Selected project does not exist or is not a sibling."
        expect(response).to redirect_to project2
      end
    end

    describe "#approve" do
      it "updates the story status to approved" do
        patch :approve, params: {id: story.id}, format: :js

        expect(story.reload.status).to eq("approved")
        expect(response).to render_template("shared/update_status")
      end
    end

    describe "#reject" do
      it "updates the story status to rejected" do
        patch :reject, params: {id: story.id}, format: :js

        expect(story.reload.status).to eq("rejected")
        expect(response).to render_template("shared/update_status")
      end
    end

    describe "#pending" do
      it "updates the story status to pending" do
        patch :pending, params: {id: story.id}, format: :js

        expect(story.reload.status).to eq("pending")
        expect(response).to render_template("shared/update_status")
      end
    end

    describe "#export" do
      it "exports a CSV file with only approved stories" do
        FactoryBot.create(:story, project: project, status: :rejected)
        FactoryBot.create(:story, project: project, status: :pending)
        get :export, params: {project_id: project.id}
        expect(response).to have_http_status(:ok)

        csv_data = CSV.parse(response.body)
        expected_csv_content = [
          ["id", "title", "description", "position"],
          [story.id.to_s, story.title, story.description, story.position.to_s]
        ]
        expect(csv_data).to eq(expected_csv_content)
      end

      context "when an admin" do
        it "exports a CSV file with all stories" do
          user = FactoryBot.create(:user)
          user.admin = true

          story2 = FactoryBot.create(:story, project: project, status: :rejected)
          story3 = FactoryBot.create(:story, project: project, status: :pending)
          get :export, params: {project_id: project.id, export_all: "1"}
          expect(response).to have_http_status(:ok)

          csv_data = CSV.parse(response.body)
          expected_csv_content = [
            ["id", "title", "description", "position"],
            [story.id.to_s, story.title, story.description, story.position.to_s],
            [story2.id.to_s, story2.title, story2.description, story2.position.to_s],
            [story3.id.to_s, story3.title, story3.description, story3.position.to_s]
          ]
          expect(csv_data).to eq(expected_csv_content)
        end
      end

      context "with comments" do
        it "exports a CSV file with only approved stories" do
          user = FactoryBot.create(:user)
          story2 = FactoryBot.create(:story, project: project, status: :approved)
          story3 = FactoryBot.create(:story, project: project, status: :approved)
          story4 = FactoryBot.create(:story, project: project, status: :approved)
          FactoryBot.create(:story, project: project, status: :rejected)
          FactoryBot.create(:story, project: project, status: :pending)
          comment1 = FactoryBot.create(:comment, user: user, story: story)
          comment1_2 = FactoryBot.create(:comment, user: user, story: story)
          comment2_1 = FactoryBot.create(:comment, user: user, story: story2)
          comment2_2 = FactoryBot.create(:comment, user: user, story: story2)
          comment3_1 = FactoryBot.create(:comment, user: user, story: story3)
          get :export, params: {project_id: project.id, export_with_comments: "1"}

          expect(response).to have_http_status(:ok)

          csv_data = CSV.parse(response.body)
          expected_csv_content = [
            ["id", "title", "description", "position", "comment"],
            [story.id.to_s, story.title, story.description, story.position.to_s, "#{comment1.user.name}: #{comment1.body}", "#{comment1_2.user.name}: #{comment1_2.body}"],
            [story2.id.to_s, story2.title, story2.description, story2.position.to_s, "#{comment2_1.user.name}: #{comment2_1.body}", "#{comment2_2.user.name}: #{comment2_2.body}"],
            [story3.id.to_s, story3.title, story3.description, story3.position.to_s, "#{comment3_1.user.name}: #{comment3_1.body}"],
            [story4.id.to_s, story4.title, story4.description, story4.position.to_s]
          ]

          expect(csv_data).to eq(expected_csv_content)
        end
      end
    end
  end
end
