class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def update?
    return !project.locked_at? if project.parent_id.nil?

    !project.parent.locked_at?
  end
end
