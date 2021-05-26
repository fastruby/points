class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:archived] == "true"
      @projects = Project.where(parent_id: nil, status: "archived")
    else
      @projects = Project.where(parent_id: nil, status: nil)
    end
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def sort
    params[:story].each_with_index do |id, index|
      Story.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  def toggle_archive
    @project = Project.find(params[:project_id])
    if !@project.archived?
      @project.update_column :status, "archived"
    else
      @project.update_column :status, nil
    end
  end

  def create
    @project = Project.new(projects_params)
    if @project.save
      flash[:success] = "Project created!"
      redirect_to "/projects"
    else
      flash[:error] = @project.errors.full_messages
      redirect_back(fallback_location: "projects/new")
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project was successfully destroyed." }
    end
  end

  def show
    @project = Project.find(params[:id])
    @stories = Story.where(project_id: @project.id).order(:position)
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(projects_params)
      flash[:success] = "Project updated!"
      redirect_to project_path(@project.id)
    else
      flash[:error] = @project.errors.full_messages
      render :edit
    end
  end

  def new_sub_project
    @project = Project.find(params[:project_id])
    @sub = Project.new(parent_id: @project)
  end

  private

  def projects_params
    params.require(:project).permit(:title, :status, :parent_id)
  end
end
