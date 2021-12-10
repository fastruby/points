module ProjectsHelper
  def estimated(story)
    @estimate_id = story.estimate_for(current_user)
    @estimate_id.present?
  end
end
