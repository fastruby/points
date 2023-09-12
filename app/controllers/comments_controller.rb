class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_story_and_project
  before_action :find_comment, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @comment = current_user.comments.build(story: @story)
    @comment.attributes = comment_params
    @comment.user_id = current_user.id
    saved = @comment.save
    respond_to do |format|
      format.html do
        if saved
          flash[:success] = "Comment created!"
          redirect_to project_story_path(@comment.story.project_id, @comment.story_id)
        else
          flash[:error] = @comment.errors.full_messages
          render :new
        end
      end
      format.js
    end
  end

  def update
    updated = @comment.update(comment_params)
    respond_to do |format|
      format.html do
        if updated
          flash[:success] = "Comment updated!"
          redirect_to project_story_path(@comment.story.project_id, @comment.story_id)
        else
          flash[:error] = @comment.errors.full_messages
          render :edit
        end
      end
      format.js
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to project_story_path(@comment.story.project_id, @comment.story_id), notice: "comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def find_comment
    @comment = current_user.comments.where(story_id: params[:story_id]).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Comment not found"
    redirect_to project_story_path(@comment.story.project_id, params[:story_id])
  end

  def load_story_and_project
    @project = Project.find(params[:project_id])
    @story = Story.find(params[:story_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
