class ActionPlansController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:project_id])

    ensure_unarchived!

    @project_stories = @project.stories.by_position
    @children =
      Project.where(parent_id: @project.id)
        .includes(:stories).references(:stories)
        .order("stories.position ASC NULLS FIRST")
  end
end
