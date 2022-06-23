class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: [:show, :edit, :update, :sort, :sort_stories, :destroy, :new_sub_project]
  before_action :ensure_unarchived!, only: [:edit, :new_sub_project, :update]

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
    params[:project].each_with_index do |id, index|
      @project.projects.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end

  def sort_stories
    params[:story].each_with_index do |id, index|
      @project.stories.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end

  def toggle_archive
    @project = Project.find(params[:id])
    @project.toggle_archived!
  end

  # PATCH /projects/1/toggle_locked.js
  def toggle_locked
    @project = Project.find(params[:id])
    @project.update(locked_at: Time.current)
  end

  def new_clone
    @original = Project.includes(:projects, stories: :estimates).find(params[:id])
  end

  def clone
    original = Project.includes(stories: :estimates).find(params[:id])
    clone = Project.create(clone_params)
    original.clone_stories_into(clone)
    if clone.parent.nil? && original.projects
      original.clone_projects_into(clone, only: params[:sub_project_ids])
    end

    flash[:success] = "Project cloned!"
    redirect_to "/projects/#{clone.id}"
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
    authorize(@project)
    if @project.update(projects_params)
      respond_to do |format|
        format.html do
          flash[:success] = "Project updated!"
          redirect_to project_path(@project.id)
        end
        format.js do
          @sidebar_projects = @project.parent ? @project.parent.projects : @project.projects
        end
      end
    else
      flash[:error] = @project.errors.full_messages
      render :edit
    end
  end

  def new_sub_project
    @sub = Project.new(parent_id: @project)
  end

  private

  def find_project
    @project = Project.find(params[:id] || params[:project_id])
  end

  def projects_params
    params.require(:project).permit(:title, :status, :parent_id)
  end

  def clone_params
    params.require(:project).permit(:title, :parent_id)
  end
end
