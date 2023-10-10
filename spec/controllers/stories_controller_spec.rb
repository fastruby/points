require "rails_helper"

RSpec.describe StoriesController, type: :controller do
  render_views

  let!(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

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
  end
end
