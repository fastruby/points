class StoriesController < ApplicationController

  before_action :project
  before_action :story, only: [:edit, :update, :destroy, :show]

  def new
    @story = Story.new
  end

  def edit
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

  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def project
    @project = Project.find(params[:project_id])
  end

  def show
    @estimate = Estimate.where(story: @story, user: current_user).first
  end

  def story
    @story = Story.find(params[:id])
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

  def stories_params
    params.require(:story).permit(:title, :description, :project_id)
  end

end
