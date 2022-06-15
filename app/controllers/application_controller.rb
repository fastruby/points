class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :rack_mini_profiler

  def hello
    render html: "hello, world!"
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  private

  # we can enable this for everybody, it's hidden by default
  def rack_mini_profiler
    show =
      if params.key?(:enable_rack_mini_profiler)
        cookies[:rack_mini_profiler] = "show"
        true
      elsif params.key?(:disable_rack_mini_profiler)
        cookies.delete(:rack_mini_profiler)
        false
      end

    if show || cookies[:rack_mini_profiler]
      Rack::MiniProfiler.authorize_request
    end
  end
end
