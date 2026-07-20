require "rails_helper"

# Projects are registered as: resources :projects, except: [:update, :edit, :create]
RSpec.describe "Madmin projects", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:project) { FactoryBot.create(:project) }

  before { login_as(admin, scope: :user) }
  after { Warden.test_reset! }

  describe "GET /madmin/projects" do
    it "lists projects" do
      get "/madmin/projects"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(project.title)
    end
  end

  describe "GET /madmin/projects/new" do
    it "renders the new form" do
      get "/madmin/projects/new"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/projects/:id" do
    it "shows the project" do
      get "/madmin/projects/#{project.id}"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /madmin/projects/:id" do
    it "destroys the project" do
      expect {
        delete "/madmin/projects/#{project.id}"
      }.to change(Project, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
