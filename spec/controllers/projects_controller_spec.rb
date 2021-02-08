require "rails_helper"

RSpec.describe ProjectsController, type: :controller do
  render_views

  let!(:project) { FactoryBot.create(:project) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe "#index" do
    before do
      get :index
    end

    it "shows me a list of all the projects" do
      expect(assigns(:projects)).to eq [project]
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
        request.env['HTTP_REFERER'] = back_path
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

  describe "#destroy" do
    it "deletes the project" do
      expect {
        delete :destroy, params: {id: project.id}
      }.to change(Project, :count).by(-1)
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

  describe "#update" do
    it "should update the project" do
      put :update, params: {id: project.id, project: {title: "New Project Title"}}

      expect(project.reload.title).to eq "New Project Title"
    end
  end
end
