class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
  end
end
