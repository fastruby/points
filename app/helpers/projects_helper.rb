module ProjectsHelper

  def estimated(story)
    @estimate_id = story.estimates.where(user_id: current_user.id).first
    @estimate_id.present?
  end

end
