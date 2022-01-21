require "rails_helper"

RSpec.describe ProjectsController, type: :controller do
  render_views

  let!(:project) { FactoryBot.create(:project, status: nil) }
  let!(:archived_project) { FactoryBot.create(:project, status: "archived") }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe "#index" do
    context "with archived params" do
      before do
        get :index, params: {archived: true}
      end

      it "shows me a list of all the archived projects" do
        expect(assigns(:projects)).to eq [archived_project]
      end
    end

    context "without archived params" do
      before do
        get :index
      end

      it "shows me a list of all the projects" do
        expect(assigns(:projects)).to eq [project]
      end
    end
  end

  describe "#new" do
    it "redirects to the new page" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "#new_sub_project" do
    before do
      get :new_sub_project, params: {project_id: project.id}
    end

    it { expect(response).to render_template :new_sub_project }
  end

  describe "#create" do
    context "with valid attributes" do
      let(:valid_params) { FactoryBot.attributes_for(:project) }

      it "creates a new project" do
        expect {
          post :create, params: {project: valid_params}
        }.to change(Project, :count).by(1)
      end

      it "redirects to the new project" do
        post :create, params: {project: valid_params}

        expect(response).to redirect_to "/projects"
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { {title: ""} }

      before do
        post :create, params: {project: invalid_attributes}
      end

      it "stays on the new template page" do
        expect(response).to redirect_to "projects/new"
      end

      it "shows a flash message" do
        expect(flash[:error]).to be_present
      end
    end

    context "with parent id and no title" do
      let(:parent_project) { {title: "parent", id: 1} }
      let(:child_project) { {title: ""} }
      let(:back_path) { project_new_sub_project_path(project_id: parent_project[:id]) }

      before do
        request.env["HTTP_REFERER"] = back_path
        post :create, params: {project: child_project}
      end

      it "stays on the new template page" do
        expect(response).to redirect_to back_path
      end

      it "shows a flash message" do
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "#show" do
    before do
      get :show, params: {id: project.id}
    end

    it "redirects to the show page" do
      expect(response).to render_template :show
    end

    it "shows the attributes for the right project" do
      expect(assigns(:project)).to eq project
    end
  end

  describe "cloning" do
    it "redirects to cloned project" do
      expect {
        post :clone, params: {id: project.id, project: {title: "New project"}}
      }.to change(Project.parents, :count).by(1)

      expect(Project.parents.last.title).to eq("New project")
      expect(response).to redirect_to "/projects/#{Project.last.id}"
      expect(flash[:success]).to eq "Project cloned!"
    end

    context "with a sub project" do
      let!(:sub_project) { FactoryBot.create(:project, parent: project) }

      it "clones the sub projects when cloning a parent" do
        expect {
          post :clone, params: {id: project.id, project: {title: "New title"}}
        }.to change(Project.parents, :count).by(1)

        last_project = Project.parents.last
        expect(last_project.id).not_to eq(project.id)
        expect(project.projects.reload.count).to eq(1)
        expect(last_project.projects.reload.count).to eq project.projects.count
      end

      it "clones a sub project as a parent project" do
        expect {
          post :clone, params: {id: sub_project.id, project: {title: "New title", parent_id: nil}}
        }.to change(Project, :count).by(1)

        last_project = Project.last
        expect(last_project.parent).to be_nil
      end

      it "clones a sub project in another parent" do
        other_project = FactoryBot.create(:project)

        expect {
          post :clone, params: {id: sub_project.id, project: {title: "New title", parent_id: other_project.id}}
        }.to change(other_project.projects.reload, :count).by(1)

        last_project = other_project.projects.reload.last
        expect(last_project.parent).to eq(other_project)
      end
    end

    context "with stories" do
      it "creates a cloned project with matching stories" do
        story = project.stories.create({title: "Story 1"})

        post :clone, params: {id: project.id, project: {title: "New title"}}

        expect(Project.last.stories.first.id).not_to eq story.id
        expect(Project.last.stories.first.title).to eq story.title
      end

      it "creates stories without estimates" do
        story = project.stories.create({title: "Story 1"})
        story.estimates.create({best_case_points: 1, worst_case_points: 3})

        post :clone, params: {id: project.id, project: {title: "New title"}}

        expect(Project.last.stories.first.estimates).to be_empty
      end
    end
  end

  context "when the project is archived" do
    before do
      project.toggle_archived!
    end

    it "doesn't allow me to edit the project" do
      get :edit, params: {id: project.id}
      expect(response).to redirect_to project_path(project)
    end

    it "doesn't allow me to update the project" do
      put :update, params: {id: project.id, project: {title: "New Project Title"}}
      expect(response).to redirect_to project_path(project)
    end
  end

  context "when the project is unarchived" do
    describe "#edit" do
      before do
        get :edit, params: {id: project.id}
      end

      it "redirects to the edit page" do
        expect(response).to render_template :edit
      end

      it "shows the fields for the project" do
        expect(assigns(:project)).to eq project
      end
    end

    describe "#destroy" do
      it "deletes the project" do
        expect {
          delete :destroy, params: {id: project.id}
        }.to change(Project, :count).by(-1)
      end
    end

    describe "#update" do
      it "should update the project" do
        put :update, params: {id: project.id, project: {title: "New Project Title"}}

        expect(project.reload.title).to eq "New Project Title"
      end
    end
  end
end
