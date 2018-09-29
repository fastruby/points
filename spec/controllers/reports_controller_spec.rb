require 'rails_helper'

RSpec.describe ReportsController, type: :controller do

  let!(:project) { FactoryBot.create(:project) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    admin = FactoryBot.create(:user, :admin)
    sign_in admin
  end

  describe "#index" do
    before do
      get :index
    end

    it "shows me a list of all the projects" do
      expect(assigns(:projects)).to eq [project]
    end
  end

  describe "#show" do
    before do
      get :show, params: { project_id: project.id }
    end

    it "redirects to the show page" do
      expect(response).to render_template :show
    end

    it "shows the attributes for the right project" do
      expect(assigns(:project)).to eq project
    end
  end


end
