class ReportsController < ApplicationController

  before_action :ensure_admin
  before_action :project, only: [:show]

  def index
    @projects = Project.all
  end

  def show
    @stories = @project.stories
    @estimates = @project.estimates
    @users = @project.users.uniq
  end

  def ensure_admin
    redirect_to root_path unless current_user.admin
  end

  def project
    @project = Project.find(params[:project_id])
  end
end
