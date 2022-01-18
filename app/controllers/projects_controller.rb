class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, except: [:index, :new, :create]
  before_action :ensure_unarchived!, only: [:edit, :new_sub_project, :duplicate, :action_plan, :update]

  def index
    status = params[:archived] == "true" ? "archived" : nil
    @projects = Project.where(parent_id: nil, status: status)
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def sort
    params[:story].each_with_index do |id, index|
      Story.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  def toggle_archive
    @project.toggle_archived!
  end

  def duplicate
    original = Project.includes(stories: :estimates).find(params[:id])
    duplicate = original.dup
    duplicate.title = "Copy of #{original.title}"
    duplicate.save

    original.stories.each { |x| duplicate.stories.create(x.dup.attributes) }

    flash[:success] = "Project created!"
    redirect_to "/projects/#{duplicate.id}"
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
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project was successfully destroyed." }
    end
  end

  def show
    @sidebar_projects = @project.parent ? @project.parent.projects : @project.projects
    @stories = @project.stories.by_position.includes(:estimates)
    @siblings = @project.siblings
  end

  def update
    if @project.update(projects_params)
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

  def find_project
    @project = Project.find(params[:id] || params[:project_id])
  end
end
