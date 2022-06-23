class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  # this is so that the project can be edited
  def update?
    !project.locked_at?
  end
end
