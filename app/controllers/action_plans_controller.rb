class ActionPlansController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:project_id])
    @project_stories = @project.stories.order(:position)
  end
end
