class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :enable_rack_mini_profiler

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
end
