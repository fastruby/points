module ProjectsHelper
  def estimated(story)
    @estimate_id = story.estimate_for(current_user)
    @estimate_id.present?
  end

  def has_projects?(sub_projects, siblings)
    sub_projects.any? || siblings.any?
  end
end
