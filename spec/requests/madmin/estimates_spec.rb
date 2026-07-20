require "rails_helper"

# Estimates are registered as: resources :estimates, except: [:update, :edit, :create]
RSpec.describe "Madmin estimates", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:estimate) { FactoryBot.create(:estimate) }

  before { login_as(admin, scope: :user) }
  after { Warden.test_reset! }

  describe "GET /madmin/estimates" do
    it "lists estimates" do
      get "/madmin/estimates"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/estimates/new" do
    it "renders the new form" do
      get "/madmin/estimates/new"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/estimates/:id" do
    it "shows the estimate" do
      get "/madmin/estimates/#{estimate.id}"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /madmin/estimates/:id" do
    it "destroys the estimate" do
      expect {
        delete "/madmin/estimates/#{estimate.id}"
      }.to change(Estimate, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
