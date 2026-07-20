require "rails_helper"

# Guards the shared madmin/application/index.html.erb pagination path.
#
# The index partial only renders the pagination nav when there is more than
# one page of results (pagy's default limit is 20). An older madmin override
# rendered a `madmin/pagy/_nav` partial that no longer ships with madmin 2.x,
# raising ActionView::MissingTemplate once a list grew past one page. The
# single-record index specs never hit this branch, so this spec creates enough
# records to paginate and exercise the nav rendering.
RSpec.describe "Madmin pagination", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }

  before { login_as(admin, scope: :user) }
  after { Warden.test_reset! }

  describe "GET /madmin/version_jumps with more than one page of records" do
    before { FactoryBot.create_list(:version_jump, 21) }

    it "renders the index with pagination navigation" do
      get "/madmin/version_jumps"

      expect(response).to have_http_status(:ok)
      # pagy builds links to subsequent pages using the `page` query param
      expect(response.body).to include("page=2")
    end
  end
end
