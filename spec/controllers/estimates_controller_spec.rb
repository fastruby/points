require 'rails_helper'

RSpec.describe EstimatesController, type: :controller do
  render_views

  let!(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }

  describe "#new" do
    it "should redirect to the new page" do
      get :new, params: { project_id: project.id, story_id: story.id }
      expect(response).to render_template :new
    end
  end

  describe "#edit" do
    let!(:foo) { FactoryBot.create(:estimate) }

    it "should redirect to the edit page" do
      get :edit, params: {id: foo.id}

      expect(assigns(:estimate)).to eq foo
    end
  end

  describe "#create" do
    context "with valid attributes" do
      let(:good_params) { FactoryBot.attributes_for(:estimate) }

      it "should create a new estimate" do
        expect do
          post :create, params: { :estimate => good_params }
        end.to change(estimate, :count).by(1)
      end

      it "should redirect to the new estimate" do
        post :create, params: { :estimate => good_params }

        expect(response).to redirect_to '/estimates'
      end
    end

    context "with invalid attributes" do
      let(:attributes) { {:title=>""} }

      it "should stay on the new template page" do
        post :create, params: { :estimate => attributes }

        expect(response).to render_template :new
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "#destroy" do
    let!(:foo) { FactoryBot.create(:estimate) }

    it "should delete the estimate" do
      expect do
        delete :destroy, params: { id: foo.id }
      end.to change(estimate, :count).by(-1)
    end
  end

  describe "#update" do
    let!(:foo) { FactoryBot.create(:estimate) }

    it "should delete the estimate" do
      expect do
        delete :destroy, params: { id: foo.id }
      end.to change(estimate, :count).by(-1)
    end
  end

end
