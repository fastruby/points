require "rails_helper"

# Users are registered as: resources :users, except: [:update, :edit, :create]
RSpec.describe "Madmin users", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:user) { FactoryBot.create(:user) }

  before { login_as(admin, scope: :user) }
  after { Warden.test_reset! }

  describe "GET /madmin/users" do
    it "lists users" do
      get "/madmin/users"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/users/new" do
    it "renders the new form" do
      get "/madmin/users/new"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /madmin/users/:id" do
    it "shows the user" do
      get "/madmin/users/#{user.id}"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /madmin/users/:id" do
    it "destroys the user" do
      expect {
        delete "/madmin/users/#{user.id}"
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
