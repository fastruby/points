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
    respond_to do |format|
      format.html do
        if saved
          flash[:success] = "Comment created!"
        else
          flash[:error] = @comment.errors.full_messages
        end

        redirect_to project_story_path(@comment.story.project_id, @comment.story_id)
      end
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
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
        flash[:success] = "Comment deleted!"
        format.html { redirect_to project_story_path(@comment.story.project_id, @comment.story_id) }
    end
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
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
