class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "hello, world!"
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  def ensure_unarchived!
    if @project.archived?
      flash[:error] = "You can perform this action in an archived project."
      redirect_to project_path(@project.id)
    end
  end
end
