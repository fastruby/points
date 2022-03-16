class ActionPlansController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:project_id])
    @project_stories = @project.stories.by_position
    @children = Project.sub_projects_with_ordered_stories(@project.id)
  end
end
