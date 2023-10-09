class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_story_and_project
  before_action :find_comment, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @comment = current_user.comments.build(story: @story)
    @comment.attributes = comment_params
    saved = @comment.save
    if saved
      flash[:success] = "Comment created!"
    else
      flash[:error] = @comment.errors.full_messages
    end

    redirect_to project_story_path(@comment.story.project_id, @comment.story_id)
  end

  def update
    updated = @comment.update(comment_params)
    if updated
      flash[:success] = "Comment updated!"
      redirect_to project_story_path(@comment.story.project_id, @comment.story_id)
    else
      flash[:error] = @comment.errors.full_messages
      render :edit
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted!"
    redirect_to project_story_path(@comment.story.project_id, @comment.story_id)
  end

  private

  def find_comment
    @comment = current_user.comments.where(story_id: params[:story_id]).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Comment not found"
    redirect_to project_story_path(params[:project_id], params[:story_id])
  end

  def load_story_and_project
    @project = Project.find(params[:project_id])
    @story = Story.find(params[:story_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Project or Story not found"
    redirect_to projects_path
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
