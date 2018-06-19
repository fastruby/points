require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "#show" do
    let (:project){ FactoryBot.create(:project) }

    context "when the project details show" do
      before do
        get :show, params: {id: project.id}
      end

      it "return the project title" do
        expect(response).to be_success
      end

      it "return the project status" do
      end
    end

    context "when the user is not logged" do
    end
  end

  describe "#create" do
  end

end
