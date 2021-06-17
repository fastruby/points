require "rails_helper"

RSpec.describe ActionPlansController, type: :controller do
  let(:project) { FactoryBot.create(:project) }

  describe "#show" do
    it "redirects to sign_in route if not authenticated" do
      get :show, params: {project_id: project.id}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns view when user is signed in" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user

      get :show, params: {project_id: project.id}

      expect(response).to be_success
      expect(response).to render_template(:show)
    end
  end
end
