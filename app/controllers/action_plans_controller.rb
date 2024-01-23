class ActionPlansController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:project_id])
    @project_stories = @project.stories.approved.by_position
    @children = Project.sub_projects_with_approved_and_ordered_stories(@project.id)
  end
end
