class ReportsController < ApplicationController

  before_action :ensure_admin
  before_action :project, only: [:show]

  def index
    @projects = Project.all
  end

  def show
    @stories = Story.where(project_id: @project.id)
  end

  def ensure_admin
    redirect_to root_path unless current_user.admin
  end

  def project
    @project = Project.find(params[:project_id])
  end
end
