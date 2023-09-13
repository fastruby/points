require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  render_views

  let!(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }
  let!(:comment) { FactoryBot.create(:comment, story: story) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "#create" do
    context "with valid attributes" do
      let(:valid_params) { FactoryBot.attributes_for(:comment) }

      it "creates a new comment" do
        expect {
          post :create, params: {project_id: project.id, story_id: story.id, comment: valid_params}
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the story path" do
        post :create, params: {project_id: project.id, story_id: story.id, comment: valid_params}

        expect(response).to redirect_to project_story_path(project.id, story.id)
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) { {body: ""} }

      it "redirects back to the story page" do
        post :create, params: {project_id: project.id, story_id: story.id, comment: invalid_params}
        expect(response).to redirect_to project_story_path(project.id, story.id)
      end
    end
  end

  describe "#destroy" do
    it "deletes the comment" do
      expect {
        delete :destroy, params: {id: comment.id, story_id: story.id, project_id: project.id}
      }.to change(Comment, :count).by(-1)
    end
  end

  describe "#edit" do
  end

  describe "#update" do
  end
end
