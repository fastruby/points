class StoriesController < ApplicationController

  before_action :project

  def new
    @story = Story.new
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])
    if @story.update_attributes(stories_params)
      flash[:success] = "Story updated!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @story.errors.full_messages
      render :edit
    end
  end

  def create
    @story = Story.new(stories_params)
    if @story.save
      flash[:success] = "Story created!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @story.errors.full_messages
      render :new
    end
  end

  def show
    @story = Story.find(params[:id])
    @estimate = Estimate.where(story: @story, user: current_user).first
  end

  def project
    @project = Project.find(params[:project_id])
  end

private

  def stories_params
    params.require(:story).permit(:title, :description, :project_id)
  end

end
