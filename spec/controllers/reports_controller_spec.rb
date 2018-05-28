require "rails_helper"
require "csv"

RSpec.describe ReportsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    admin = FactoryBot.create(:user, :admin)
    sign_in admin
  end

  describe "#index" do
    let!(:project) { FactoryBot.create(:project) }

    before do
      get :index
    end

    it "shows me a list of all the projects" do
      expect(assigns(:projects)).to eq [project]
    end
  end

  describe "#show" do
    context "using HTML response format" do
      let!(:project) { FactoryBot.create(:project) }

      before do
        get :show, params: {project_id: project.id}
      end

      it "redirects to the show page" do
        expect(response).to render_template :show
      end

      it "shows the attributes for the right project" do
        expect(assigns(:project)).to eq project
      end
    end

    context "specifying CSV format" do
      let(:estimate) { FactoryBot.create(:estimate) }
      let(:story) { estimate.story }
      let(:project) { story.project }

      before do
        get :show, params: {project_id: project.id}, format: :csv
      end

      it "responds with csv formatted report" do
        csv = CSV.parse(response.body).to_a
        expect(csv[0]).to eq(["Story", "Best Estimate Average", "Worst Estimate Average"])
        expect(csv[1]).to eq([story.title, story.best_estimate_average.to_s, story.worst_estimate_average.to_s])
      end
    end
  end
end
