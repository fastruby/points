class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(projects_params)
    if @project.save
      flash[:success] = "Project created!"
      redirect_to "/projects"
    else
      flash[:error] = @project.errors.full_messages
      render 'projects/new'
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def projects_params
    params.require(:project).permit(:title, :status)
  end

end
