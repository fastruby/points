class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery with: :exception
  before_action :enable_rack_mini_profiler
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def hello
    render html: "hello, world!"
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  private

  # we can enable this for everybody, it's hidden by default
  def enable_rack_mini_profiler
    Rack::MiniProfiler.authorize_request
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def ensure_unarchived!
    if @project.archived? || @project.parent&.archived?
      flash[:error] = "You can't perform this action on an archived project."
      redirect_to project_path(@project.id)
    end
  end
end
