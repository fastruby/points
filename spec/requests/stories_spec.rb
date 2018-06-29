require 'rails_helper'

RSpec.describe "Stories", type: :request do
  describe "GET /stories" do
    it "works! (now write some real specs)" do
      get project_stories_path(@project.id)
      expect(response).to have_http_status(200)
    end
  end
end
