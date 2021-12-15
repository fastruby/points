class ReportsController < ApplicationController
  before_action :ensure_admin
  before_action :project, only: [:show]

  def index
    @projects = Project.all
  end

  def show
    respond_to do |format|
      format.html do
        @stories = @project.stories.by_position.includes(:estimates)
        @estimates = @project.estimates
        @users = @project.users.uniq
        @real_score_exists = @stories.pluck(:real_score).any?
        @can_generate_estimate_report = @stories.any? && stories_have_minimum_estimates?
      end

      format.csv do
        report = Report.new(@project)
        render plain: report.to_csv
      end
    end
  end

  private

  def stories_have_minimum_estimates?
    @stories.all? { |story| story.estimates_count >= Report::MINIMUM_ESTIMATES_PER_STORY }
  end

  def ensure_admin
    redirect_to root_path unless current_user.admin
  end

  def project
    @project = Project.find(params[:project_id])
  end
end
