class ActionPlansController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:project_id])
    @project_stories = @project.stories.order(:position, :created_at)
    @children = Project.where(parent_id: @project.id).includes(:stories).references(:stories).order("stories.position")
  end
end
