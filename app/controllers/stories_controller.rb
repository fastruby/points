class StoriesController < ApplicationController

  before_action :find_project
  before_action :find_story, only: [:edit, :update, :destroy, :show]

  def new
    @story = Story.new
  end

  def edit
  end

  def create
    @story = Story.new(stories_params)
    @story.project_id = @project.id

    if @story.save
      flash[:success] = "Story created!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @story.errors.full_messages
      render :new
    end
  end

  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show
    @estimate = Estimate.where(story: @story, user: current_user).first
  end

  def update
    if @story.update_attributes(stories_params)
      flash[:success] = "Story updated!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @story.errors.full_messages
      render :edit
    end
  end


private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_story
    @story = Story.find(params[:id])
  end

  def stories_params
    params.require(:story).permit(:title, :description, :project_id)
  end

end
