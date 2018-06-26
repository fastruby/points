class StoriesController < ApplicationController
  def new
    @story = Story.new
  end

  def create
    @story = Story.new(stories_params)
    if @story.save
      flash[:success] = "Story created!"
      redirect_to @story.project
    else
      flash[:error] = @story.errors.full_messages
      render 'stories/new'
    end
  end

  def show
    @story = Story.find(params[:id])
  end

private

  def stories_params
    params.require(:story).permit(:title, :description, :project_id)
  end

end
