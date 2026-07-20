module Madmin
  class DashboardController < Madmin::ApplicationController
    def show
      @stats = {
        projects_active: Project.active.count,
        projects_archived: Project.where(status: "archived").count,
        stories_pending: Story.pending.count,
        stories_approved: Story.approved.count,
        stories_rejected: Story.rejected.count,
        estimates: Estimate.count,
        users: User.count,
        comments: Comment.count,
        version_jumps: VersionJump.count
      }

      @recent_stories = Story.order(created_at: :desc).limit(5)
      @recent_projects = Project.order(created_at: :desc).limit(5)
      @recent_estimates = Estimate.includes(:story, :user).order(created_at: :desc).limit(5)
    end
  end
end
