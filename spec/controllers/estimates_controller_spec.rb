require "rails_helper"

RSpec.describe EstimatesController, type: :controller do
  render_views

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:story) { FactoryBot.create(:story, project: project) }
  let(:estimate) { FactoryBot.create(:estimate, story: story, user: user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "#new" do
    it "redirects to the new page" do
      get :new, params: {id: estimate.id, story_id: story.id, project_id: project.id}
      expect(response).to render_template :new
    end
  end

  describe "#edit" do
    before do
      get :edit, params: {id: estimate.id, story_id: story.id, project_id: project.id}
    end

    it "redirects to the edit page" do
      expect(response).to render_template :edit
    end

    it "shows the fields for the estimate" do
      expect(assigns(:estimate)).to eq estimate
    end
  end

  describe "#edit as other user" do
    it "disallows editing another users' estimate" do
      user2 = FactoryBot.create(:user)
      estimate2 = FactoryBot.create(:estimate, story: story, user: user2)

      get :edit, params: {id: estimate2.id, story_id: story.id, project_id: project.id}

      expect(response).to redirect_to project_path(story.project)
      expect(flash[:error]).to eq "Estimate not found"
    end
  end

  describe "#create" do
    context "with valid attributes" do
      let(:estimate_params) {
        {best_case_points: 1, worst_case_points: 3}
      }

      it "creates a new estimate" do
        expect {
          post :create, params: {project_id: project.id,
                                 story_id: story.id,
                                 estimate: estimate_params}
        }.to change(Estimate, :count).by(1)
      end

      it "redirects to the new estimate" do
        post :create, params: {story_id: story.id,
                               project_id: project.id,
                               estimate: estimate_params}

        expect(response).to redirect_to project_path(project.id)
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { {best_case_points: ""} }

      before do
        post :create, params: {story_id: story.id,
                               project_id: project.id,
                               estimate: invalid_attributes}
      end

      it "stays on the new template page" do
        expect(response).to render_template :new
      end

      it "shows a flash message" do
        expect(flash[:error]).to be_present
      end
    end

    context "if there is already an estimate" do
      let(:params) do
        {
          story_id: story.id,
          project_id: project.id,
          estimate: {
            best_case_points: 1,
            worst_case_points: 3
          }
        }
      end

      let!(:estimate) { FactoryBot.create(:estimate, story: story, user: user, best_case_points: 2, worst_case_points: 5) }

      it "does not create a new estimate" do
        expect {
          post :create, params: params
        }.to change(Estimate, :count).by(0)
      end

      it "updates the current estimate" do
        expect(estimate.best_case_points).to be 2
        expect(estimate.worst_case_points).to be 5

        post :create, params: params

        estimate.reload
        expect(estimate.best_case_points).to be 1
        expect(estimate.worst_case_points).to be 3
      end
    end
  end

  describe "#destroy" do
    it "deletes the estimate" do
      estimate # call `estimate` so rspec creates the object

      expect {
        delete :destroy, params: {id: estimate.id, story_id: story.id, project_id: project.id}
      }.to change(Estimate, :count).by(-1)
    end

    it "disallows destroying another users' estimate" do
      user2 = FactoryBot.create(:user)
      estimate2 = FactoryBot.create(:estimate, story: story, user: user2)

      delete :destroy, params: {id: estimate2.id, story_id: story.id, project_id: project.id}

      expect(response).to redirect_to project_path(story.project)
      expect(flash[:error]).to eq "Estimate not found"
    end
  end

  describe "#update" do
    it "updates the estimate" do
      put :update, params: {id: estimate.id,
                            story_id: story.id,
                            project_id: project.id,
                            estimate: {best_case_points: "7", worst_case_points: "10"}}

      expect(estimate.reload.best_case_points).to eq 7
    end

    it "disallows updating another users' estimate" do
      user2 = FactoryBot.create(:user)
      estimate2 = FactoryBot.create(:estimate, story: story, user: user2)

      put :update, params: {id: estimate2.id,
                            story_id: story.id,
                            project_id: project.id,
                            estimate: {best_case_points: "7", worst_case_points: "10"}}

      expect(response).to redirect_to project_path(story.project)
      expect(flash[:error]).to eq "Estimate not found"
    end
  end
end
