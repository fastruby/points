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
end
