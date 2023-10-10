require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  render_views

  let!(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project) }
  let!(:story) { FactoryBot.create(:story, project: project) }
  let!(:comment) { FactoryBot.create(:comment, story: story, user: user) }

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
      delete :destroy, params: {project_id: project.id, story_id: story.id, id: comment.id}
      expect(Comment.exists?(comment.id)).to be_falsey
      expect(response).to redirect_to project_story_path(project.id, story.id)
    end

    it "disallows destroying another users' comment" do
      user2 = FactoryBot.create(:user)
      comment2 = FactoryBot.create(:comment, story: story, user: user2)

      delete :destroy, params: {id: comment2.id, story_id: story.id, project_id: project.id}

      expect(response).to redirect_to project_story_path(project.id, story.id)
      expect(flash[:error]).to eq "Comment not found"
    end
  end

  describe "#edit" do
    before do
      get :edit, params: {id: comment.id, story_id: story.id, project_id: project.id}
    end

    it "redirects to the edit page" do
      expect(response).to render_template :edit
    end

    it "shows the fields for the comment" do
      expect(assigns(:comment)).to eq comment
    end
  end

  describe "#edit as other user" do
    it "disallows editing another users' comment" do
      user2 = FactoryBot.create(:user)
      comment2 = FactoryBot.create(:comment, story: story, user: user2)

      get :edit, params: {id: comment2.id, story_id: story.id, project_id: project.id}

      expect(response).to redirect_to project_story_path(project.id, story.id)
      expect(flash[:error]).to eq "Comment not found"
    end
  end

  describe "#update" do
    it "updates the body for the comment" do
      put :update, params: {
        id: comment.id,
        story_id: story.id,
        project_id: project.id,
        comment: {
          body: "test123"
        }
      }
      expect(comment.reload.body).to eq "test123"
    end

    it "disallows updating another users' comment" do
      user2 = FactoryBot.create(:user)
      comment2 = FactoryBot.create(:comment, story: story, user: user2)

      put :update, params: {id: comment2.id,
                            story_id: story.id,
                            project_id: project.id,
                            comment: {body: "test123"}}

      expect(response).to redirect_to project_story_path(project.id, story.id)
      expect(flash[:error]).to eq "Comment not found"
    end
  end
end
