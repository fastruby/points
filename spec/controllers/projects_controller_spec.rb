require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  render_views

  describe "#index" do
    let!(:project) { FactoryBot.create(:project) }

    before do
      get :index
    end

    it "should show me a list of all the projects" do
      expect(assigns(:projects)).to eq [project]
    end
  end

  describe "#new" do
    it "should redirect to the new page" do
      get :new
    end
  end

  describe "#edit" do
    let!(:foo) { FactoryBot.create(:project) }

    it "should redirect to the edit page" do
      get :edit, params: {id: foo.id}

      expect(assigns(:project)).to eq foo
    end
  end

  describe "#create" do
    context "with valid attributes" do
      let(:good_params) { FactoryBot.attributes_for(:project) }

      it "should create a new project" do
        expect do
          post :create, params: { :project => good_params }
        end.to change(Project, :count).by(1)
      end

      it "should redirect to the new project" do
        post :create, params: { :project => good_params }

        expect(response).to redirect_to '/projects'
      end
    end

    context "with invalid attributes" do
      let(:attributes) { {:title=>""} }

      it "should redirect to the new project" do
        post :create, params: { :project => attributes }

        expect(response).to render_template :new
      end
    end
  end

  describe "#destroy" do
    let!(:foo) { FactoryBot.create(:project) }

    it "should delete the project" do
      expect do
        delete :destroy, params: { id: foo.id }
      end.to change(Project, :count).by(-1)
    end
  end

end
